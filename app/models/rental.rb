class Rental < ActiveRecord::Base

  state_machine initial: :active do
    event :return do
      transition :active => :returned
    end

    after_transition any => :returned do |rental|
      rental.book.release
    end
  end

  belongs_to :user
  belongs_to :book

end
