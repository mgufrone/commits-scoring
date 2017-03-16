module CommitsHelper
    def last_unscored_commit
        Commit.unscored.latest.joins(:user).where('username IN (?) and message not like ?', refactory_users, '%merge%').first
    end
    def refactory_users 
        [
            "hystolytc",
            "ahmadahmadi14",
            "deneuv34",
            "erdivartanovich",
            "htwibowo",
            "kristoforusrp",
            "shilohchis",
            "w4ndry",
            "sutani",
            "tyokusuma",
            "prayuditb",
            "rafi-isakh",
            "syamsulanwr"
        ]
    end
    def attachment(commit)  
        {
                color: '#757575',
                text: "##{commit.id} - #{commit.sha}",
                title: "##{commit.id} - #{commit.message}",
                title_link: "#{commit.repository.url}/commit/#{commit.sha}",
                author_name: commit.user.full_name,
                author_link: "https://github.com/#{commit.user.username}",
                ts: commit.commited_at.to_i
            }
    end
end
