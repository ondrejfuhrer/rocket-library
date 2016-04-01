require 'rails_helper'

describe TimeDifference do

  def self.with_each_class(&block)
    classes = [Time, Date, DateTime]

    classes.each do |clazz|
      context "with a #{clazz.name} class" do
        instance_exec clazz, &block
      end
    end
  end

  def self.with_each_time_class(&block)
    classes = [Time, DateTime]

    classes.each do |clazz|
      context "with a #{clazz.name} class" do
        instance_exec clazz, &block
      end
    end
  end

  describe '.between' do
    it 'returns a new TimeDifference instance' do
      start_time = Time.new(2011, 1)
      end_time = Time.new(2011, 12)

      expect(TimeDifference.between(start_time, end_time)).to be_a(TimeDifference)
    end
  end

  describe '#in_each_component' do
    with_each_class do |clazz|
      it 'returns time difference in each component' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_each_component).to eq(TimeDifferenceResult.from_hash({ years: 0.91, months: 10.98, weeks: 47.71, days: 334.0, hours: 8016.0, minutes: 480960.0, seconds: 28857600.0 }))
      end
    end
  end

  describe '#in_years' do
    with_each_class do |clazz|
      it 'returns time difference in years based on Wolfram Alpha' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_years).to eq(0.91)
      end

      it 'returns an absolute difference' do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_years).to eq(0.91)
      end
    end
  end

  describe '#in_months' do
    with_each_class do |clazz|
      it 'returns time difference in months based on Wolfram Alpha' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_months).to eq(10.98)
      end

      it 'returns an absolute difference' do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_months).to eq(10.98)
      end
    end
  end

  describe '#in_weeks' do
    with_each_class do |clazz|
      it 'returns time difference in weeks based on Wolfram Alpha' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_weeks).to eq(47.71)
      end

      it 'returns an absolute difference' do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_weeks).to eq(47.71)
      end
    end
  end

  describe '#in_days' do
    with_each_class do |clazz|
      it 'returns time difference in weeks based on Wolfram Alpha' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_days).to eq(334.0)
      end

      it 'returns an absolute difference' do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_days).to eq(334.0)
      end
    end
  end

  describe '#in_hours' do
    with_each_class do |clazz|
      it 'returns time difference in hours based on Wolfram Alpha' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_hours).to eq(8016.0)
      end

      it 'returns an absolute difference' do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_hours).to eq(8016.0)
      end
    end
  end

  describe '#in_minutes' do
    with_each_class do |clazz|
      it 'returns time difference in minutes based on Wolfram Alpha' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_minutes).to eq(480960.0)
      end

      it 'returns an absolute difference' do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_minutes).to eq(480960.0)
      end
    end
  end

  describe '#in_seconds' do
    with_each_class do |clazz|
      it 'returns time difference in seconds based on Wolfram Alpha' do
        start_time = clazz.new(2011, 1)
        end_time = clazz.new(2011, 12)

        expect(TimeDifference.between(start_time, end_time).in_seconds).to eq(28857600.0)
      end

      it 'returns an absolute difference' do
        start_time = clazz.new(2011, 12)
        end_time = clazz.new(2011, 1)

        expect(TimeDifference.between(start_time, end_time).in_seconds).to eq(28857600.0)
      end
    end
  end

  ### Moved from rental spec

  describe '#in_general' do
    { '2015' => :non_leap, 2016 => :leap }.each do |year, desc|
      context "in #{desc.to_s.humanize} year [#{year}]" do
        with_each_time_class do |clazz|
          [*1..23].each do |sample|
            it "by #{sample} #{sample == 1 ? 'hour' : 'hours'}" do
              t1 = clazz.new year.to_i, 1, 30, 11
              t2 = t1 - sample.hours

              result = TimeDifference.between(t1, t2).in_general

              expect(result).to be_instance_of TimeDifferenceResult
              expect(result.years).to eq 0
              expect(result.months).to eq 0
              expect(result.weeks).to eq 0
              expect(result.days).to eq 0
              expect(result.hours).to eq sample
              expect(result.minutes).to eq 0
              expect(result.seconds).to eq 0

              # Result with DST ignore flag should be the same
              expect(result).to eq TimeDifference.between(t1, t2, true).in_general
            end
          end
        end

        with_each_class do |clazz|
          [*1..6].each do |sample|
            it "by #{sample} #{sample == 1 ? 'day' : 'days'}" do
              t1 = clazz.new year.to_i, 1, 30
              t2 = t1 - sample.days

              result = TimeDifference.between(t1, t2).in_general

              expect(result).to be_instance_of TimeDifferenceResult
              expect(result.years).to eq 0
              expect(result.months).to eq 0
              expect(result.weeks).to eq 0
              expect(result.days).to eq sample
              expect(result.hours).to eq 0
              expect(result.minutes).to eq 0
              expect(result.seconds).to eq 0

              # Result with DST ignore flag should be the same
              expect(result).to eq TimeDifference.between(t1, t2, true).in_general
            end
          end
        end

        with_each_class do |clazz|
          [*1..4].each do |sample|
            it "by #{sample} #{sample == 1 ? 'week' : 'weeks'}" do
              t1 = clazz.new year.to_i, 1, 30
              t2 = t1 - sample.weeks

              result = TimeDifference.between(t1, t2).in_general

              expect(result).to be_instance_of TimeDifferenceResult
              expect(result.years).to eq 0
              expect(result.months).to eq 0
              expect(result.weeks).to eq sample
              expect(result.days).to eq 0
              expect(result.hours).to eq 0
              expect(result.minutes).to eq 0
              expect(result.seconds).to eq 0

              # Result with DST ignore flag should be the same
              expect(result).to eq TimeDifference.between(t1, t2, true).in_general

              # Result should be also the same when switching the arguments
              expect(result).to eq TimeDifference.between(t2, t1).in_general
            end
          end
        end

        with_each_class do |clazz|
          [*1..11].each do |sample|
            context 'with DST ignore' do
              it "by #{sample} #{sample == 1 ? 'month' : 'months'}" do
                t1 = clazz.new year.to_i, 12
                t2 = clazz.new year.to_i, (12 - sample)

                result = TimeDifference.between(t1, t2, true).in_general

                expect(result).to be_instance_of TimeDifferenceResult
                expect(result.years).to eq 0
                expect(result.months).to eq sample
                expect(result.weeks).to eq 0
                expect(result.days).to eq 0

                # DateTime does not count with DST changes
                # TODO this check does not work correctly local vs CI, not sure why
                if clazz == Date and sample >= 2 and sample < 9
                  expect(result.hours).to satisfy { |item| [0, 1].include? item }
                else
                  expect(result.hours).to eq 0
                end


                expect(result.minutes).to eq 0
                expect(result.seconds).to eq 0

                # Result should be also the same when switching the arguments
                expect(result).to eq TimeDifference.between(t2, t1, true).in_general
              end
            end
            context 'without DST ignore' do
              it "by #{sample} #{sample == 1 ? 'month' : 'months'}" do
                t1 = clazz.new year.to_i, 12
                t2 = clazz.new year.to_i, (12 - sample)

                result = TimeDifference.between(t1, t2).in_general

                expect(result).to be_instance_of TimeDifferenceResult
                expect(result.years).to eq 0
                expect(result.months).to eq sample
                expect(result.weeks).to eq 0
                expect(result.days).to eq 0

                # DateTime does not count with DST changes
                # TODO this check does not work correctly local vs CI, not sure why
                if clazz != DateTime and sample >= 2 and sample < 9
                  # Time has changed in 10. and 3. month
                  expect(result.hours).to satisfy { |value| [1, 0].include?(value) }
                else
                  expect(result.hours).to eq 0
                end
                
                expect(result.minutes).to eq 0
                expect(result.seconds).to eq 0

                # Result should be also the same when switching the arguments
                expect(result).to eq TimeDifference.between(t2, t1).in_general
              end
            end
          end
        end

        with_each_class do |clazz|
          # We test last 20 years
          [*1..20].each do |sample|
            it "by #{sample} #{sample == 1 ? 'year' : 'years'}" do
              t1 = clazz.new year.to_i, 12
              t2 = clazz.new (year.to_i - sample), 12

              result = TimeDifference.between(t1, t2).in_general

              expect(result).to be_instance_of TimeDifferenceResult
              expect(result.years).to eq sample
              expect(result.months).to eq 0
              expect(result.weeks).to eq 0
              expect(result.days).to eq 0
              expect(result.hours).to eq 0
              expect(result.minutes).to eq 0
              expect(result.seconds).to eq 0

              # Result with DST ignore flag should be the same
              expect(result).to eq TimeDifference.between(t1, t2, true).in_general

              # Result should be also the same when switching the arguments
              expect(result).to eq TimeDifference.between(t2, t1).in_general
            end
          end
        end
      end
    end
  end
end
