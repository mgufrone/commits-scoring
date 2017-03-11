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
        commits = Commit.joins(:user).where('username in (?)', refactory_users)
        commits = commits.where('DATE(commited_at) = ?', Chronic.parse(date).strftime('%Y-%m-%d')) if date != nil
        commits = commits.where('DATE(comnited_at) BETWEEN ? AND ?', Chronic.parse(start_date).strftime('%Y-%m-%d'), Chronic.parse(end_date).strftime('%Y-%m-%d')) unless date != nil
        total_commits = commits.count
        scored_commits = commits.scored.count
        unscored_commits = commits.unscored.count
        fields = []
        fields << {
            small: true,
            text: "Total Commits",
            value: total_commits
        }
        fields << {
            small: true,
            text: "Scored Commits",
            value: scored_commits
        }
        fields << {
            small: true,
            text: "Unscored commits",
            value: unscored_commits
        }

        attachments = []
        attachments << {
            title: "Summary for all saved commits",
            small: true,
            fields: fields
        }
        @client.typing
        @client.send text: "<@#{data.user}> This is what you need!", channel: data.channel, attachments: attachments.to_json
    end
end