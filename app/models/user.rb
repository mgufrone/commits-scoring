require 'gravatarify'
class User < ActiveRecord::Base
  include Gravatarify::Helper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
          # :registerable,
        #  :recoverable,
         :rememberable, :trackable, :validatable,
         :lockable

  has_many :providers, class_name: "UserProvider"
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :phone, presence: true
  def self.from_omniauth(auth)
    current = where(email: auth.info.email).first_or_create do |user|
      user.phone = user.email
      user.full_name = auth.info.name
    end
    if current.persisted?
      current.providers.where(provider: auth.provider, uid: auth.uid).first_or_create
    end
    current
  end
  def profile_image
    gravatar_url(email)
  end
end
