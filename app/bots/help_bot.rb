class HelpBot 
    def initialize(client)
        @client = client
    end
    def pattern
        /help|what can you do/imx
    end
    def process(message, data)
        @client.typing
        [
            "Try this command:",
            "`show me summary/report (for today, yesterday)`",
            "It will show you the commit summary report",
            "show me performance of (user)",
            "it will show you the performance of specific person",
            "count all commits (for|at|between) (date|start to end) ",
            "it will show you of total number of commits"
            "score/mark commit_id to score_value: ",
            "this will do to mark a commit and score it out"
        ]
        @client.send text: "<@#{data.user}> Hai there!", channel: data.channel
    end
end