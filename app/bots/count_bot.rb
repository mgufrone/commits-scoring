class CountBot
    include CommitsHelper
    def initialize(client)
        @client = client
    end
    def pattern
        /count\s(all\s)?commits?\s?((for|from|at|between)\s(((?<start_date>.+)\sto\s(?<end_date>.+))|(?<date>.+)))?/i
    end
    def process(message, data)
        matches = pattern.match message
        date = matches[:date]
        start_date = matches[:start_date]
        end_date = matches[:end_date]
        commits = Commit.joins(:user).where('username in (?) and message not like ?', refactory_users, '%merge%')
        commits = commits.where('DATE(commited_at) = ?', Chronic.parse(date).strftime('%Y-%m-%d')) if date != nil
        if start_date != nil and end_date != nil
            commits = commits.where('DATE(commited_at) BETWEEN ? AND ?', Chronic.parse(start_date).strftime('%Y-%m-%d'), Chronic.parse(end_date).strftime('%Y-%m-%d')) 
        end
        total_commits = commits.count
        scored_commits = commits.scored.count.count
        unscored_commits = commits.unscored.count.count
        fields = []
        fields << {
            short: true,
            title: "Total Commits",
            value: total_commits
        }
        fields << {
            short: true,
            title: "Scored Commits",
            value: scored_commits || 0
        }
        fields << {
            short: true,
            title: "Unscored commits",
            value: unscored_commits || 0
        }

        attachments = []
        attachments << {
            title: "Summary for all saved commits",
            small: true,
            fields: fields,
            text: "Commit Summary for Refactory"
        }
        puts attachments.to_json
        @client.typing
        @client.send text: "<@#{data.user}> This is what you need!", channel: data.channel, attachments: attachments.to_json
    end
end