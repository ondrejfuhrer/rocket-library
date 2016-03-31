class TimeDifferenceResult

  # Creates a time difference result form hash
  #
  # === Return
  # @return [TimeDifferenceResult]
  #
  def self.from_hash(hash)
    return new hash[:years], hash[:months], hash[:weeks], hash[:days], hash[:hours], hash[:minutes], hash[:seconds]
  end

  # Returns human readable string representation of the result
  # Uses translation strings 'time_difference.#{type}' and separate the values by given separator
  #
  # === Parameters
  # @param [String] separator used as a separator between each values
  # @param [Boolean] detailed if set to true it prints also minutes and seconds
  #
  # === Return
  # @return [String]
  #
  def humanize(separator = ' ', detailed = false)
    result = []

    result << I18n.t('time_difference.year', { count: @years }) if @years > 0
    result << I18n.t('time_difference.month', { count: @months }) if @months > 0
    result << I18n.t('time_difference.week', { count: @weeks }) if @weeks > 0
    result << I18n.t('time_difference.day', { count: @days }) if @days > 0
    result << I18n.t('time_difference.hour', { count: @hours }) if @hours > 0
    if detailed
      result << I18n.t('time_difference.minute', { count: @hours }) if @hours > 0
      result << I18n.t('time_difference.second', { count: @hours }) if @hours > 0
    else
      result << I18n.t('time_difference.less_than_hour') if result.empty?
    end

    result.join(separator)
  end

  # Provides "hash access" to the values
  # If this is called with unknown parameter, 0 is returned
  #
  # === Parameters
  # @param [Symbol] item
  #
  # === Return
  # @return [Numeric]
  #
  def [](item)
    if [:years, :months, :weeks, :days, :hours, :minutes, :seconds].include? (item)
      public_send item
    else
      0
    end
  end

  # Basic comparison override
  #
  # === Parameters
  # @param [TimeDifferenceResult] other
  #
  def ==(other)
    years == other.years and months == other.months and weeks == other.weeks and days == other.days and hours == other.hours and minutes == other.minutes and seconds == other.seconds
  end

  # === Return
  # @return [Numeric] number of years
  #
  def years
    @years
  end

  # === Return
  # @return [Numeric] number of months
  #
  def months
    @months
  end

  # === Return
  # @return [Numeric] number of weeks
  #
  def weeks
    @weeks
  end

  # === Return
  # @return [Numeric] number of days
  #
  def days
    @days
  end

  # === Return
  # @return [Numeric] number of hours
  #
  def hours
    @hours
  end

  # === Return
  # @return [Numeric] number of minutes
  #
  def minutes
    @minutes
  end

  # === Return
  # @return [Numeric] number of seconds
  #
  def seconds
    @seconds
  end

  private

  # === Parameters
  # @param [Numeric] years
  # @param [Numeric] months
  # @param [Numeric] weeks
  # @param [Numeric] days
  # @param [Numeric] hours
  # @param [Numeric] minutes
  # @param [Numeric] seconds
  #
  def initialize(years = 0, months = 0, weeks = 0, days = 0, hours = 0, minutes = 0, seconds = 0)
    @years = years
    @months = months
    @weeks = weeks
    @days = days
    @hours = hours
    @minutes = minutes
    @seconds = seconds
  end
end
