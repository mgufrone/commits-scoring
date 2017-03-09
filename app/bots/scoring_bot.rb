class ScoringBot
    def initialize(client)
        @client = client
    end
    def pattern
        /(mark|score)\s(for)?(?<commit>\d+)\s?to?\s?(?<score>[\d\,\.]+)/imx
    end
    def process(message, data) 
        matches = pattern.match(message)
        commit = Commit.find(matches[:commit])
        user = @client.client.web_client.users_info user: data.user
        scorer = User.find_or_create_by(username: user.user.name) do |current|
            current.email = user.user.profile.email
            current.phone = user.user.profile.email
            current.full_name = user.user.profile.real_name
            current.password = user.user.profile.email
        end        
        if commit.scores.where(user_id: scorer.id).count == 0
            commit.scores.create(user: scorer, score: matches[:score].gsub(',', '.').to_f)
            @client.send text: "Score saved. Thanks <@#{data.user}>", channel: data.channel
        else
            commit.scores.where(user_id: scorer.id).update(score: matches[:score].gsub(',','.').to_f)
            @client.send text: "Score updated. Thanks <@#{data.user}>", channel: data.channel
        end
    end
end