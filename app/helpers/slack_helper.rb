module SlackHelper
    class SlackBot
        def initialize(client, data)
            @client = client
            @channel = data.channel
            @message = data.text
            @data = data
        end
        def processors
            [
                HelloBot.new(self),
                CommitBot.new(self),
                ScoringBot.new(self),
                SummaryBot.new(self)
            ]
        end
        def process
            processed = false
            return if @message.match(Regexp.new("@#{@client.self.id}", Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED)) == nil
            return if @data.user == @client.self.id
            @message.gsub!(Regexp.new("\\<@#{@client.self.id}\\>", 'imx'), '').strip!
            processors.each do |bot|
                if bot.pattern.match(@message) 
                    processed = true
                    bot.process(@message, @data)
                    return
                end
            end
            StupidBot.new(self).process(@message, @data)
        end
        def typing
            @client.typing channel: @channel
        end
        def send(message)
            @client.web_client.chat_postMessage message.merge(icon_url: 'http://data.whicdn.com/images/108032712/large.jpg', username: "Cutie Policia") 
        end
        def client
            @client
        end
    end
end
