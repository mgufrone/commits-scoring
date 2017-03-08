require 'gravatarify'
require 'digest/bubblebabble'
class User < ApplicationRecord
  include Gravatarify::Helper
  include BCrypt
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :lockable
  has_many :commits
  has_many :repositories, through: :commits
  has_many :scores, through: :commits
  has_many :providers, class_name: "UserProvider"
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :phone, presence: true
  scope :scored, -> {
    joins("LEFT OUTER JOIN commits on commits.user_id = users.id").joins("LEFT OUTER JOIN scores on scores.commit_id = commits.id")
    .select("AVG(scores.score) as average_score, users.*, COUNT(commits.id) as total_commits")
    .group("users.id")
  }
  def self.from_omniauth(auth)
    current = where(email: auth.info.email).first_or_create do |user|
      user.phone = user.email
      user.full_name = auth.info.name
      user.password = Digest::MD5.bubblebabble("#{user.email}-#{Devise.friendly_token[10,20]}").to_s.upcase
    end
    if current.persisted?
      current.providers.where(provider: auth.provider, uid: auth.uid).first_or_create
    end
    current
  end
  def profile_image
    gravatar_url(email)
  end
  def password
    @password ||= Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end
  def clear_password
    self.encrypted_password = nil
  end
end
