class CommitBot
    def initialize(client)
       @client = client 
    end
    def pattern
        /(?<state>scored|unscored)?\s?(?<order>latest|asc|ascending|descending|desc|oldest)?\s?commits\s?(?<date>)?/imx
    end
    def process(message, data)
       @client.send text: "Hold on", channel: data.channel
       @client.typing 
       commits = Commit.all
       show_score = false
       matches = pattern.match(message)
        case matches[:state]
        when "scored"
            commits = commits.scored            
            show_score = true
        when "unscored"
            commits = commits.unscored
        else
            commits = commits.unscored
        end
        case matches[:order]
        when "latest", 'desc', 'descending'
            commits = commits.latest
        when "oldest", 'asc', 'ascending'
            commits = commits.oldest   
        end
        attachments = commits.take(20).map do |commit|
            score = 0
            score = commit.scores.map {|score| score.score}.reduce(:+)/commit.scores.size if commit.scores.size > 0
            color = '#1B5E20' if score > 8.5
            color = '#C0CA33' if score > 7.5 and score <= 8.5
            color = '#FF8F00' if score > 6.5 and score <= 7.5
            color = '#B71C1C' if score <= 6.5
            color = '#757575' if score == 0
            fields = []
            fields = [
                {
                    title: "Score",
                    short: false,
                    value: score,
                }
            ] if score > 0
            {
                color: color,
                fields: fields,
                text: "##{commit.id} - #{commit.sha}",
                title: "##{commit.id} - #{commit.message}",
                title_link: "#{commit.repository.url}/commit/#{commit.sha}",
                author: commit.user.full_name,
                ts: commit.commited_at.to_i
            }
        end
        @client.send text: "There you go", channel: data.channel, attachments: attachments.to_json
    end
end