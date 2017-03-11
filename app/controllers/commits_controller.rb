class CommitsController < BaseController
    skip_after_action :verify_policy_scoped, :verify_authorized
    skip_before_action :verify_authenticity_token
    include ScoreHelper
    def index
        @client = Slack::Web::Client.new
        @web_client = @client
        scorer = scorer(params[:user][:id])
        commit_id = params[:callback_id]
        score = params[:actions].first[:value]        
        save_score(commit_id, scorer, score)
        begin
            save_score(matches[:commit], scorer, matches[:score].gsub(',','.').to_f)
            @client.chat_postMessage text: "Score saved. Thanks <@#{data.user}>", channel: data.channel
        rescue => e
            @client.chat_postMessage text: "Something went wrong. Check the commit id please! <@#{data.user}>"
        end
        render json: {result: :success, score: score}
    end
    private
    def commit
        params.permit(:actions, :team, :callback_id, :channel, :user, :action_ts, :message_ts, :attachment_id, :token, :original_message, :response_url)
    end
end
