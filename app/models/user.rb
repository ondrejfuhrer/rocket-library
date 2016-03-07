class User < ActiveRecord::Base
  extend Enumerize
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  state_machine initial: :active do
    event :remove do
      transition :active => :deleted
    end
  end

  has_many :rentals

  ROLES = [:admin, :manager, :user]
  enumerize :role, in: ROLES, default: :user

  def self.from_omniauth(access_token)
    data = access_token.info

    user = User.where(:email => data['email']).first

    unless user
      user = User.create(
        first_name: data['first_name'],
        last_name: data['last_name'],
        email: data['email'],
        password: Devise.friendly_token[0, 20],
        google_avatar_url: data.image
      )
    end
    user
  end

  def full_name
    self.first_name + ' ' + self.last_name
  end

end
