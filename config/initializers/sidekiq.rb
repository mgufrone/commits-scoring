Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["admin-sidekiq", "yourpassword"]
end
