module ScoreHelper
    include CommitsHelper
    def scorer(data)
        user = @web_client.users_info user: data
        User.find_or_create_by(username: user.user.name) do |current|
            current.email = user.user.profile.email
            current.phone = user.user.profile.email
            current.full_name = user.user.profile.real_name
            current.password = user.user.profile.email
        end
    end
    def save_score(commit_id, scorer, score)
        commit = Commit.find commit_id
        is_create = false
        score = commit.scores.find_or_create_by(user: scorer) do |scoring|
            is_create = true
            scoring.score = score
        end
        if !is_create 
            score.update(score: score)
        end
        {is_create: is_create, score: score}
    end
end
