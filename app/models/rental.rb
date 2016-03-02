class Rental < ActiveRecord::Base

  state_machine initial: :active do
    event :return do
      transition any => :returned
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
