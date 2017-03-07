class Score < ApplicationRecord
  belongs_to :commit
  belongs_to :user
end
