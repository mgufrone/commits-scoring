class OauthAppController < Doorkeeper::ApplicationsController
  http_basic_authenticate_with name: "mgufrone", password: "28ER67fi$"
end
