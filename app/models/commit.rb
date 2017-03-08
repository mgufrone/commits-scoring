class Commit < ApplicationRecord
  belongs_to :user
  has_many :scores
  belongs_to :repository
  scope :scored, -> {joins("LEFT OUTER JOIN scores ON scores.commit_id = commits.id").group("commits.id").having("COUNT(scores.id)>0")}
  scope :unscored, -> {joins("LEFT OUTER JOIN scores ON scores.commit_id = commits.id").group("commits.id").having("COUNT(scores.id)=0")}
  scope :latest, -> { order commited_at: :desc }
  scope :oldest, -> { order commited_at: :asc }
end
