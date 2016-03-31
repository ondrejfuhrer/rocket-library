require 'rails_helper'

RSpec.describe TimeDifferenceResult do
  describe '.from_hash' do
    it 'should assign properly values (read from getters)' do
      hash = {
        years: 10,
        months: 5,
        weeks: 1,
        days: 5,
        hours: 10,
        minutes: 55,
        seconds: 23
      }

      result = TimeDifferenceResult.from_hash hash

      expect(result).to be_instance_of TimeDifferenceResult
      expect(result.years).to eq hash[:years]
      expect(result.months).to eq hash[:months]
      expect(result.weeks).to eq hash[:weeks]
      expect(result.days).to eq hash[:days]
      expect(result.hours).to eq hash[:hours]
      expect(result.minutes).to eq hash[:minutes]
      expect(result.seconds).to eq hash[:seconds]
    end

    it 'should assign properly values (read as hash)' do
      hash = {
        years: 0,
        months: 8,
        weeks: 0,
        days: 1,
        hours: 9,
        minutes: 9,
        seconds: 0
      }

      result = TimeDifferenceResult.from_hash hash

      expect(result).to be_instance_of TimeDifferenceResult
      expect(result[:years]).to eq hash[:years]
      expect(result[:months]).to eq hash[:months]
      expect(result[:weeks]).to eq hash[:weeks]
      expect(result[:days]).to eq hash[:days]
      expect(result[:hours]).to eq hash[:hours]
      expect(result[:minutes]).to eq hash[:minutes]
      expect(result[:seconds]).to eq hash[:seconds]
    end
  end

  describe '#[]' do
    10.times do
      word = FFaker::Lorem.word
      context "with random word [#{word}]" do
        it 'should return 0' do
          td = TimeDifferenceResult.new 1, 1, 1, 1, 1, 1, 1

          expect(td[word]).to eq 0
        end
      end
    end

    [:years, :months, :weeks, :days, :hours, :minutes, :seconds].each do |value|
      context 'with values set up' do
        it "should return 1 by accessing #[:#{value.to_s}]" do
          td = TimeDifferenceResult.new 1, 1, 1, 1, 1, 1, 1

          expect(td[value]).to eq 1
        end
      end

      context 'with default values' do
        it "should return 0 by accessing #[:#{value.to_s}]" do
          td = TimeDifferenceResult.new

          expect(td[value]).to eq 0
        end
      end
    end
  end

  describe '#humanize' do
    context 'with all values 1' do
      it 'should return not detailed result' do
        result = TimeDifferenceResult.new 1, 1, 1, 1, 1, 1

        expect(result.humanize).to eq '1 year 1 month 1 week 1 day 1 hour'
      end

      it 'should return detailed result with defined separator' do
        result = TimeDifferenceResult.new 1, 1, 1, 1, 1, 1

        expect(result.humanize(',', true)).to eq '1 year,1 month,1 week,1 day,1 hour,1 minute,1 second'
      end
    end

    [
      [15, 0, 3, 1, 0, 55, 1, '15 years 3 weeks 1 day'],
      [0, 1, 5, 0, 6, 5, 11, '1 month 5 weeks 6 hours'],
      [1, 3, 0, 5, 1, 33, 22, '1 year 3 months 5 days 1 hour'],
      [6, 5, 4, 3, 2, 0, 0, '6 years 5 months 4 weeks 3 days 2 hours'],
    ].each do |value|

      year = value[0]
      month = value[1]
      week = value[2]
      day = value[3]
      hour = value[4]
      minute = value[5]
      second = value[6]

      expected_result = value[7]

      context "with random values [#{year}, #{month}, #{week}, #{day}, #{hour}, #{minute}, #{second}]" do
        it 'should return non detailed result' do
          result = TimeDifferenceResult.new year, month, week, day, hour, minute, second

          expect(result.humanize).to eq expected_result
        end
      end
    end
  end
end
