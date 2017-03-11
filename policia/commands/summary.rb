module Policia
    module Commands
        class Summary < SlackRubyBot::Commands::Base
            match /(summary|report)/ do |client, data, match|
                desc "I'm gonna give you summary report within your criteria"
            end
        end
    end
end