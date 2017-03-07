class PayloadController < ApplicationController
  def receive
    author = User.find_or_create_by(username: commit[:author][:username])
    Commit.create(

    )
  end
  private
    def commit
      params[:head_commit]
    end
    def repository
      params[:repository]
    end
end
