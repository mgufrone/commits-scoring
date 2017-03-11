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
        save_score(matches[:commit], scorer, matches[:score].gsub(',','.').to_f)
        Octokit.create_commit_comment commit.repository.name, commit.sha, "Score: #{matches[:score].gsub(',','.').to_f}"
        @client.send text: "<@#{data.user}> #{asking_sentence}", channel: data.channel, attachments: [attachment(last_unscored_commit)].to_json
    end
end