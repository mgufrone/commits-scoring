class SummaryBot
    include CommitsHelper
    def initialize(client)
        @client = client
    end
    def pattern
        /(
            (
                (?<action>summary|report)
                (\s(order|sort)\s?(by\s)?(?<column>\w+)?\s?(?<direction>asc|desc|highest|lowest))?
           )|((performance\s(of|for)\s(\<?\(?<user>[\@\w\_\d]+)\>?))
          )(\s(
              (start|from|at|for|between)\s
                (
                    (?<start_at>.+)\s(and|to|until|till|-)\s(?<ends_at>.+)
                    |
                    (?<date>.+)
                 )
            )
          )?/mix
    end
    def process(message, data)
        @message = message
        @data = data
        @client.typing
        @client.send text: "Right away, sir!", channel: data.channel
        @client.typing
        matches = pattern.match message
        @message_left = message.gsub(pattern, '').gsub(Regexp.new("\\<@#{@client.client.self.id}\\>"), '')
        return send_single_user(matches) if matches[:user] != nil
        send_summary(matches)
    end
    def send_single_user(matches)
        user_lookup = matches[:user]
        if /my|me/.match(user_lookup) != nil 
            user_lookup = @data.user
        elsif matches[:user].include?('@') == nil
            users = @client.client.web_client.users_list[:members].select do |user|
                user.name =~ Regexp.new(matches[:user], 'imx') or user.profile.real_name =~ Regexp.new(matches[:user], 'imx')
            end
            user_lookup = users.first.id
        end
        user = @client.client.web_client.users_info user: user_lookup
        user_find = User.where("username like ? or full_name like ? or full_name like ? or email like ?", "%#{user.user.name}%", "%#{user.user.real_name.split(' ').first}%", "%#{user.user.profile.real_name.split(' ').last}%", "%#{user.user.profile.email}%").first
        commits = user_find.commits
        scores = user_find.scores
        repositories = user_find.repositories
        if matches != nil and matches[:starts_at] != nil and matches[:ends_at] != nil
            commits = commits.where(commited_at: Chronic.parse(matches[:starts_at])..Chronic.parse(matches[:ends_at]))
            scores = scores.where(commited_at: Chronic.parse(matches[:starts_at])..Chronic.parse(matches[:ends_at]))
            repositories = repositories.where(commited_at: Chronic.parse(matches[:starts_at])..Chronic.parse(matches[:ends_at]))
        end
        if matches != nil and matches[:date] != nil and Chronic.parse(matches[:date]) != nil
            commits = commits.where('DATE(commited_at) = ?', Chronic.parse(matches[:date]).strftime('%Y-%m-%d'))
            scores = scores.where("DATE(commits.commited_at) = ?", Chronic.parse(matches[:date]).strftime('%Y-%m-%d'))
            repositories = repositories.where("DATE(commits.commited_at) = ?", Chronic.parse(matches[:date]).strftime('%Y-%m-%d'))
        end
        fields = []
        score = scores.sum(:score) || 0
        fields << {
            title: "Average Commit Score",
            value: "#{score} (from evaluated commits: #{commits.scored.to_a.count})",
            short: true
        }
        fields << {
            title: "Contributed Repository",
            value: repositories.group("repositories.id").to_a.size,
            short: true
        }
        fields << {
            title: "Total Commits",
            value: commits.count,
            short: true
        }
        attachments = [{
            color: '#1B5E20',
            fields: fields,
            title: "Summary for #{user_find.full_name}",
            text: "Summary for #{user_find.full_name}",
            author_name: 'Policia',
            ts: Time.now.to_i
        }]
        @client.send channel: @data.channel, text: "There you go <@#{@data.user}>", attachments: attachments.to_json
    end
    def send_summary(matches)
        users = User.scored.where("username IN (?)", refactory_users)
        attachments = []
        if matches != nil and matches[:starts_at] != nil and matches[:ends_at] != nil
           users = users.where(commited_at: Chronic.parse(matches[:starts_at])..Chronic.parse(matches[:ends_at]))
        end
        if matches != nil and matches[:date] != nil and Chronic.parse(matches[:date]) != nil
           users = users.where("DATE(commits.commited_at) = ?", Chronic.parse(matches[:date]).strftime('%Y-%m-%d'))
        end
        order_column = "sum_score"
        order_direction = "desc"
        available_columns = ["average_score", "sum_score", "full_name", "total_commits"]
        if order_matches != nil
            if order_matches[:column] != nil
                column = order_matches[:column].strip!.gsub(' ', '_').underscore
                order_column = column if available_columns.include?(column)
            end
            if order_matches[:direction] != nil
                case order_matches[:direction]
                when "asc", "ascending", "lowest"
                    order_direction = "asc"
                when "desc", "descending", "highest"
                    order_direction = "desc"
                end
            end
        end
        users.order("#{order_column} #{order_direction}").reverse.each_with_index.map do |user, key|
            fields = []
            fields << {
                title: "Sum of Commit Score",
                value: user[:sum_score] || 0,
                short: true
            }

            fields << {
                title: "Average Commit Score",
                value: user[:average_score] || 0,
                short: true
            }
            fields << {
                title: "Total Commits",
                value: user[:total_commits],
                short: true
           }
            attachments << {
                color: '#1B5E20',
                fields: fields,
                title: "#{users.count - key}. #{user.full_name}",
                text: "Summary for #{user.full_name}",
                author_name: 'Policia',
                ts: Time.now.to_i
            }
        end
        if attachments.size > 0
            @client.send channel: @data.channel, text: "There you go <@#{@data.user}>", attachments: attachments.to_json
        else 
            @client.send channel: @data.channel, text: "Sorry no report for that query. you can try other date, <@#{data.user}>"
        end
    end
end