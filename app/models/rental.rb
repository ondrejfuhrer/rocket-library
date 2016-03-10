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
  default_scope { order('returned_at DESC') }

  after_create do
    self.book.rent
  end

  def rental_time
    data = TimeDifference.between(Time.zone.now, self.created_at).in_general

    result = []
    result << I18n.t('application.year', { count: data[:years] }) if data[:years] > 0
    result << I18n.t('application.month', { count: data[:months] }) if data[:months] > 0
    result << I18n.t('application.week', { count: data[:weeks] }) if data[:weeks] > 0
    result << I18n.t('application.day', { count: data[:days] }) if data[:days] > 0
    result << I18n.t('application.hour', { count: data[:hours] }) if data[:hours] > 0

    result << I18n.t('application.less_than_hour') if result.empty?

    result.join(' ')
  end

end
