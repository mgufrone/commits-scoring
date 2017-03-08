class StupidBot
    def initialize(client)
        @client = client
    end
    def process(message, data)
        @client.typing
        @client.send channel: data.channel, text: "I didn't understand that. Sorry. :pray:"
    end
end