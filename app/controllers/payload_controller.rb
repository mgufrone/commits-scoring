class PayloadController < BaseController
  skip_after_action :verify_policy_scoped, :verify_authorized
  skip_before_action :verify_authenticity_token
  include PayloadHelper
  def receive
    render json: {message: "Commit saved", commit: save_payload(params)}
  end
end
