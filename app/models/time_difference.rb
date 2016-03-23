class TimeDifference

  private_class_method :new

  TIME_COMPONENTS = [:years, :months, :weeks, :days, :hours, :minutes, :seconds]

  def self.between(start_time, end_time)
    new start_time, end_time
  end

  def self.calculate(time_dif)
    new time_dif
  end

  def in_years
    in_component(:years)
  end

  def in_months
    (@time_diff / (1.day * 30.42)).round(2)
  end

  def in_weeks
    in_component(:weeks)
  end

  def in_days
    in_component(:days)
  end

  def in_hours
    in_component(:hours)
  end

  def in_minutes
    in_component(:minutes)
  end

  def in_seconds
    @time_diff
  end

  def in_each_component
    Hash[TIME_COMPONENTS.map do |time_component|
      [time_component, public_send("in_#{time_component}")]
    end]
  end

  def in_general
    remaining = @time_diff

    data = Hash[TIME_COMPONENTS.map do |time_component|
      rounded_time_component = (remaining / 1.send(time_component)).floor
      remaining -= rounded_time_component.send(time_component)

      [time_component, rounded_time_component]
    end]

    hour_difference = 0
    if data[:years] > 0
      hour_difference = calculate_hour_difference
    end

    day_difference = 0
    if data[:months] > 0
      day_difference = calculate_day_difference @from_date
    end

    data[:days] = data[:days] - day_difference if day_difference and data[:days] > 0
    data[:hours] = data[:hours] - hour_difference if hour_difference and data[:hours] > 0

    data
  end

  def humanize_general
    data = self.in_general

    result = []

    result << I18n.t('application.year', { count: data[:years] }) if data[:years] > 0
    result << I18n.t('application.month', { count: data[:months] }) if data[:months] > 0
    result << I18n.t('application.week', { count: data[:weeks] }) if data[:weeks] > 0
    result << I18n.t('application.day', { count: (data[:days]) }) if (data[:days]) > 0
    result << I18n.t('application.hour', { count: (data[:hours]) }) if (data[:hours]) > 0

    result << I18n.t('application.less_than_hour') if result.empty?

    result.join(' ')
  end

  private

  def initialize(start_time, end_time = nil)
    if end_time.nil?
      @time_diff = start_time.to_i.abs
    else
      @from_date = start_time.to_time
      start_time = time_in_seconds(start_time)
      end_time = time_in_seconds(end_time)

      @time_diff = (end_time - start_time).abs
    end
  end

  def time_in_seconds(time)
    time.to_time.to_f
  end

  def in_component(component)
    (@time_diff / 1.send(component)).round(2)
  end

  # It seems that the result differs in this rotation - 18h, 12h, 6h, 0h, so we calculate the difference accordingly
  #
  # === Return
  # @return [Numeric]
  #
  def calculate_hour_difference
    mod = 3
    [*1..self.in_years].each do |m|
      mod = ((m % 4) - 4).abs
    end
    6 * mod
  end

  # Since the gem is calculating a month as 30 day, to precise result we need to figure out how many days wee need to forget about
  # This approach should be also able to calculate proper difference when leap year is involved
  #
  # === Parameters
  # @param [Time] from_date
  #
  # === Return
  # @return [Numeric]
  #
  def calculate_day_difference(from_date)
    day_difference = 0

    if @from_date
      [*1..self.in_months].each do |m|
        a = (from_date - m.months)
        day_difference += 1 if (Date.gregorian_leap?(a.year) and a.month == 2)
        day_difference += Time.days_in_month(a.month, a.year) - 30
      end
    end

    day_difference
  end

end
