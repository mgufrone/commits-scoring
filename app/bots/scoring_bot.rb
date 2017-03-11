class ScoringBot
    include ScoreHelper
    include AskingHelper
    def initialize(client)
        @client = client
    end
    def pattern
        /(mark|score)\s((for|of)\s)?(?<commit>\d+)\s(to|is)?\s?(?<score>[\d\,\.]+)/imx
    end
    def process(message, data) 
        @web_client = @client.client.web_client
        matches = pattern.match(message)
        commit = Commit.find(matches[:commit])
        scorer = scorer(data.user)
        begin
            save_score(matches[:commit], scorer, matches[:score].gsub(',','.').to_f)
            @client.send text: asking_sentence, channel: data.channel, attachments: [attachment(last_unscored_commit)].to_json
        rescue => e
            @client.send text: "Something went wrong. Check the commit id please! <@#{data.user}>", channel: data.channel, attachments: [{
                color: '#ff0000',
                fallback: 'Error',
                text: "Trace:\n#{e.backtrace}",
                mrkdwn_in: ["text"]
            }]
            raise
        end
    end
    def send_another_commit
        last_commit_attachment = attachment(last_unscored_commit)

    end
end