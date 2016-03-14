class WatchList < ActiveRecord::Base

  belongs_to :rental
  belongs_to :user

  state_machine initial: :active do
    event :fulfill do
      transition :active => :fulfilled
    end
  end

  scope :active, -> { with_state(:active) }
end
