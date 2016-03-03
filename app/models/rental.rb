class Rental < ActiveRecord::Base

  validates_with RentalValidator, on: :create

  state_machine initial: :active do
    event :return do
      transition any => :returned
    end

    before_transition any => :returned do |rental|
      rental.returned_at = Time.now
    end

    after_transition any => :returned do |rental|
      rental.book.release
    end
  end

  belongs_to :user
  belongs_to :book

  scope :active, -> { with_state(:active) }
  scope :returned, -> { with_state(:returned) }

  after_create do
    self.book.rent
  end

end
