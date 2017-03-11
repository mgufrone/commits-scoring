module AskingHelper
    include GratitudeHelper
    def asking_sentence
        sentence = pattern.shuffle.first.examples.first
        sentence.gsub!("{gratitude}", gratitude_word)
    end
    def pattern
        [
            /\{gratitude\}\! This one also need your attention\./,
            /\{gratitude\}\! what about this\?/,
            /\{gratitude\}\! what is the score for this one\?/,
            /\{gratitude\}\! Please evaluate this commit\!/,
        ]
    end
end
