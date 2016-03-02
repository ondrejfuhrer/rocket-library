class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  state_machine initial: :active do
    event :remove do
      transition :active => :deleted
    end
  end

  attr_accessor :state

  has_many :rentals

  def full_name
    self.first_name + ' ' + self.last_name
  end

end
