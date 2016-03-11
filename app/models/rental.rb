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

  default_scope { order('returned_at DESC') }
  scope :active, -> { with_state(:active) }
  scope :returned, -> { with_state(:returned) }

  after_create do
    self.book.rent
  end

  def rental_time
    from_date = (self.returned? ? self.returned_at : Time.current).utc
    data_object = TimeDifference.between(from_date, self.created_at.utc)
    data = data_object.in_general

    day_difference = 0
    hour_difference = 0

    result = []
    if data[:years] > 0
      # It seems that the result differs in this rotation - 18h, 12h, 6h, 0h, so we calculate the difference accordingly
      mod = 3
      [*1..data_object.in_years].each do |m|
        mod = ((m % 4) - 4).abs
      end
      hour_difference = 6 * mod
      result << I18n.t('application.year', { count: data[:years] })
    end
    if data[:months] > 0
      # Since the gem is calculating a month as 30 day, to precise result we need to figure out how many days wee need to forget about
      # This approach should be also able to calculate proper difference when leap year is involved
      [*1..data_object.in_months].each do |m|
        a = (from_date - m.months)
        day_difference += 1 if (Date.gregorian_leap?(a.year) and a.month == 2)
        day_difference += Time.days_in_month(a.month, a.year) - 30
      end
      result << I18n.t('application.month', { count: data[:months] })
    end
    result << I18n.t('application.week', { count: data[:weeks] }) if data[:weeks] > 0
    result << I18n.t('application.day', { count: (data[:days] - day_difference) }) if (data[:days] - day_difference) > 0
    result << I18n.t('application.hour', { count: (data[:hours] - hour_difference) }) if (data[:hours] - hour_difference) > 0

    result << I18n.t('application.less_than_hour') if result.empty?

    result.join(' ')
  end

end
