module GratitudeHelper
    def gratitude_words
        [
            "Thanks",
            "Thank You",
            "Awesome",
            "Great",
            "Excellent",
            "Perfect",
            "Wonderful",
            "Amazing",
            "Wicked",
            "Superb",
            "Cool",
            "Brilliant"
        ]
    end
    def gratitude_word
        gratitude_words.shuffle.first
    end
end
