namespace :slack do
  desc "TODO"
  task start: :environment do
    client = Slack::RealTime::Client.new
    client.on :hello do
      puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
    end

    client.on :message do |data|
      puts "receive message #{data.text}"
      SlackHelper::SlackBot.new(client, data).process
    end

    client.on :close do |_data|
      puts "Client is about to disconnect"
    end

    client.on :closed do |_data|
      puts "Client has disconnected successfully!"
    end

    client.start!
  end

end
