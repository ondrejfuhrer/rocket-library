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
  has_many :books
  has_many :watch_lists

  ROLES = [:admin, :manager, :user]
  enumerize :role, in: ROLES, default: :user

  # Returns a User instance from given OmniAuth::AuthHash. If that user does not exits
  # it creates a new one. For already created users it checks if google avatar has changed
  # and of yes it updates the value
  #
  # ==== Parameters
  # @param [OmniAuth::AuthHash] access_token
  #
  # === Return
  # @return User
  #
  def self.from_omniauth(access_token)
    data = access_token.info

    user = User.where(:email => data['email']).first

    if user
      user.update(google_avatar_url: data.image) if data.image != user.google_avatar_url
    else
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


  # Determine if the user has already created watch list for given rental
  #
  # ==== Parameters
  # @param [Rental] rental
  #
  # === Return
  # @return [Boolean]
  #
  def has_watch_list_for_rental(rental)
    self.watch_lists.map {|w| w.rental }.include?(rental)
  end

  # Returns full name by concatenating first name and last name
  #
  # ==== Return
  # @return [String]
  #
  def full_name
    data = []
    data << self.first_name unless self.first_name.blank?
    data << self.last_name unless self.last_name.blank?
    data.join(' ')
  end

end
