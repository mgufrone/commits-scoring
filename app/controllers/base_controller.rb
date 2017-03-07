class BaseController < ApplicationController
  before_action :authenticate_app_or_user!
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  def authenticate_app_or_user!
    return true if request.headers.include?("X-GitHub-Delivery") 
    authenticate_user!
  end
end
