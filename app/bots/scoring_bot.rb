class ScoringBot
    include ScoreHelper
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
            @client.send text: "Score saved. Thanks <@#{data.user}>", channel: data.channel
        rescue => e
            @client.send text: "Something went wrong. Check the commit id please! <@#{data.user}>"
        end
    end
end