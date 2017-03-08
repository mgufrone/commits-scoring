class HelloBot
    def initialize(client)
        @client = client
    end
    def pattern
        /hello/i
    end
    def process(message, data)
        @client.typing
        @client.send text: "<@#{data.user}> Hai there!", channel: data.channel
    end
end