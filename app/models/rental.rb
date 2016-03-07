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

  def rental_time
    data = TimeDifference.between(Time.zone.now, self.created_at).in_general

    result = []
    result << "#{data[:months]} months" if data[:months] > 0
    result << "#{data[:days]} days" if data[:days] > 0
    result << "#{data[:hours]} hours" if data[:hours] > 0

    result << 'less than hour' if result.empty?

    result.join(' ')
  end

end
