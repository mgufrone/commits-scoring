Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, '1690828041204040', 'a54143adc57fe9763c52c1bd7286194e',
            scope: 'email', info_fields: 'name,email,id'
  provider :google_oauth2, '847894889258-4iiuta4kkpe9u3cvrsnc4fsmirhga2r1.apps.googleusercontent.com', 'uNu-XUxcd9e7ADzCoTmS_BTO',
            scope: 'email, profile, plus.me', image_aspect_ratio: "original"
end
