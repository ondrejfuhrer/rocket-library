class TimeDifference

  private_class_method :new

  TIME_COMPONENTS = [:years, :months, :weeks, :days, :hours, :minutes, :seconds]

  # Returns a new instance for calculating a time difference between given dates
  #
  # === Return
  # @return [TimeDifference]
  #
  def self.between(start_time, end_time, dst_ignore = false)
    new start_time, end_time, dst_ignore
  end

  # Returns a new instance for calculating all components based on given time difference
  #
  # === Return
  # @return [TimeDifference]
  #
  def self.calculate(time_dif)
    new time_dif
  end

  #
  # === Return
  # @return [Numeric]
  #
  def in_years
    in_component(:years)
  end

  #
  # === Return
  # @return [Numeric]
  #
  def in_months
    (@time_diff / (1.day * 30.42)).round(2)
  end

  #
  # === Return
  # @return [Numeric]
  #
  def in_weeks
    in_component(:weeks)
  end

  #
  # === Return
  # @return [Numeric]
  #
  def in_days
    in_component(:days)
  end

  #
  # === Return
  # @return [Numeric]
  #
  def in_hours
    in_component(:hours)
  end

  #
  # === Return
  # @return [Numeric]
  #
  def in_minutes
    in_component(:minutes)
  end

  #
  # === Return
  # @return [Integer]
  #
  def in_seconds
    @time_diff
  end

  # Returns calculated difference in every component, so i.e. for difference 1 year it will return:
  #     year: 1.0, months: 12.0, days: 365.0, hours: 8760, minutes: 525600.0, seconds: 31536000.0
  #
  # === Return
  # @return [TimeDifferenceResult]
  #
  def in_each_component
    TimeDifferenceResult.from_hash(Hash[TIME_COMPONENTS.map do |time_component|
      [time_component, public_send("in_#{time_component}")]
    end])
  end

  # Returns a calculated difference, i.e. for difference 1 year, 3 months, 5 days, 5 seconds it will return:
  #     years: 1, months: 3, days: 5, hours: 0, minutes: 0, seconds: 5
  #
  # === Return
  # @return [TimeDifferenceResult]
  #
  def in_general
    remaining = @time_diff

    calculated_months = 0

    data = Hash[TIME_COMPONENTS.map do |time_component|
      if @to_date and @from_date and :years == time_component
        if @to_date > @from_date
          calculation_month = @to_date - 1.month
        else
          calculation_month = @from_date - 1.month
        end

        days_in_month = Time.days_in_month(calculation_month.month, calculation_month.year)

        rounded_time_component = 0
        while (remaining - (days_in_month * 24 * 3600)) >= 0

          calculated_months += 1

          if calculated_months == 12
            calculated_months = 0
            rounded_time_component += 1
          end

          remaining -= (days_in_month * 24 * 3600)
          calculation_month -= 1.month
          days_in_month = Time.days_in_month(calculation_month.month, calculation_month.year)
        end
      elsif @to_date and @from_date and time_component == :months
        rounded_time_component = calculated_months
      else
        rounded_time_component = (remaining / 1.send(time_component)).floor
        remaining -= rounded_time_component.send(time_component)
      end

      [time_component, rounded_time_component]
    end]

    hour_difference = 0
    if data[:years] > 0
      hour_difference = calculate_hour_difference
    end

    data[:hours] = data[:hours] - hour_difference if hour_difference and data[:hours] > 0

    TimeDifferenceResult.from_hash data
  end

  private

  def initialize(start_time, end_time = nil, dst_ignore = false)
    @dst_ignore = dst_ignore
    if end_time.nil?
      @time_diff = start_time.to_i.abs
    else

      @from_date = start_time.to_time
      @to_date = end_time.to_time

      dst_change = 0
      # If the input is already a time, wee need to adjust the values,
      # otherwise casting to time will do this for us
      if @dst_ignore and start_time.is_a?(Time)
        if (@from_date.dst? and not @to_date.dst?) or (not @from_date.dst? and @to_date.dst?)
          dst_change = -3600
        end
      end

      start_time = time_in_seconds(start_time)
      end_time = time_in_seconds(end_time)

      @time_diff = (end_time - start_time).abs + dst_change
    end
  end

  def time_in_seconds(time)
    time.to_time.to_f
  end

  def in_component(component, time_diff = nil)
    time_diff = @time_diff if time_diff.nil?
    (time_diff / 1.send(component)).round(2)
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

end
