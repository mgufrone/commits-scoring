module PayloadHelper
    class PayloadProcess
       def initialize(response)
           @response = response
        end
       def commit
            @response[:head_commit]
        end
        def repository
            Repository.find_or_create_by(url: @response[:repository][:html_url], name: @response[:repository][:full_name]) do |repo|
                repo.label = @response[:repository][:name]
            end
        end
        def author 
            User.find_or_create_by(username: commit[:author][:username]) do |user|
                user.email = commit[:author][:email]
                user.full_name = commit[:author][:name]
                user.password = commit[:author][:username]
                user.phone = commit[:author][:email]
            end
        end
        def save_payload
            Commit.find_or_create_by(sha: commit[:id]) do |new_commit|
                new_commit.user = author
                new_commit.message = commit[:message]
                new_commit.commited_at = DateTime.parse(commit[:timestamp]).strftime('%Y-%m-%d %H:%M:%S')
                new_commit.sha = commit[:id]
                new_commit.repository = repository
            end
        end 
    end
    def save_payload(response)
        PayloadProcess.new(response).save_payload
    end
end
