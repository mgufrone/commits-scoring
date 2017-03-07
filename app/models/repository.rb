class Repository < ApplicationRecord
    has_many :commits
    has_many :users, through: :commits
end
