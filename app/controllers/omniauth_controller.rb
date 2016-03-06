class OmniauthController < ApplicationController
  def create
    @user = User.from_omniauth(auth_hash)
    sign_in @user
    redirect_to "/"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
