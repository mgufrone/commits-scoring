class DashboardController < BaseController
  skip_after_action :verify_policy_scoped
  def index
    @title = "Dashboard"
  end
end
