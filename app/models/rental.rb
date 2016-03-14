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
      # @type [Rental] rental
      rental.book.release
      rental.watch_lists.active.each do |w|
        UserMailer.watchlist(w.user, rental).deliver
        w.fulfill
        w.save!
      end
    end
  end

  belongs_to :user
  belongs_to :book
  has_many :watch_lists

  default_scope { order('returned_at DESC') }
  scope :active, -> { with_state(:active) }
  scope :returned, -> { with_state(:returned) }

  after_create do
    self.book.rent
  end

  # Returns a rental time in human readable format. If the rental is still active, the value shows for how long it is rented until now,
  # if the rental is already returned it shows the difference between created time and return time
  #
  # === Return
  # @return [String]
  #
  def rental_time
    from_date = (self.returned? ? self.returned_at : Time.current).utc
    data_object = TimeDifference.between(from_date, self.created_at.utc)
    data = data_object.in_general

    day_difference = 0
    hour_difference = 0

    result = []
    if data[:years] > 0
      hour_difference = calculate_hour_difference data_object
      result << I18n.t('application.year', { count: data[:years] })
    end
    if data[:months] > 0
      day_difference = calculate_day_difference data_object, from_date
      result << I18n.t('application.month', { count: data[:months] })
    end
    result << I18n.t('application.week', { count: data[:weeks] }) if data[:weeks] > 0
    result << I18n.t('application.day', { count: (data[:days] - day_difference) }) if (data[:days] - day_difference) > 0
    result << I18n.t('application.hour', { count: (data[:hours] - hour_difference) }) if (data[:hours] - hour_difference) > 0

    result << I18n.t('application.less_than_hour') if result.empty?

    result.join(' ')
  end

  private

  # It seems that the result differs in this rotation - 18h, 12h, 6h, 0h, so we calculate the difference accordingly
  #
  # === Return
  # @return [Numeric]
  #
  def calculate_hour_difference(data_object)
    mod = 3
    [*1..data_object.in_years].each do |m|
      mod = ((m % 4) - 4).abs
    end
    6 * mod
  end

  # Since the gem is calculating a month as 30 day, to precise result we need to figure out how many days wee need to forget about
  # This approach should be also able to calculate proper difference when leap year is involved
  #
  # === Return
  # @return [Numeric]
  #
  def calculate_day_difference(data_object, from_date)
    day_difference = 0

    [*1..data_object.in_months].each do |m|
      a = (from_date - m.months)
      day_difference += 1 if (Date.gregorian_leap?(a.year) and a.month == 2)
      day_difference += Time.days_in_month(a.month, a.year) - 30
    end

    day_difference
  end

end
