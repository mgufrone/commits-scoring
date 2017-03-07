class Commit < ApplicationRecord
  belongs_to :user
  has_many :scores
  belongs_to :repository
end
