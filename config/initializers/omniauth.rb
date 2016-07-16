Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, ENV["FACEBOOK_CLIENT_ID"], ENV["FACEBOOK_CLIENT_SECRET"],
            scope: 'email', info_fields: 'name,email,id'
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
            scope: 'email, profile, plus.me', image_aspect_ratio: "original"
end
