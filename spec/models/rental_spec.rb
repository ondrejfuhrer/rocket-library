require 'rails_helper'

describe 'Rental#rental_time' do

  def randomize_time_by_minutes(time)
    time - ([*0..59].sample).minutes
  end

  it 'return "less than hour" for active new rental' do
    [*1..59].each do |sample|
      created_at = sample.minutes.ago

      book = FactoryGirl.create :book
      rental = Rental.create book: book, created_at: created_at

      expect(rental.created_at).to eq created_at
      expect(rental.rental_time).to eq 'less than hour'
    end
  end

  it 'return "1 hour" for active rental' do
    created_at = randomize_time_by_minutes 1.hour.ago

    book = FactoryGirl.create :book
    rental = Rental.create book: book, created_at: created_at

    expect(rental.created_at).to eq created_at
    expect(rental.rental_time).to eq '1 hour'
  end

  it 'return "x hours" for active rentals' do
    [*2..23].each do |sample|
      created_at = randomize_time_by_minutes sample.hour.ago

      book = FactoryGirl.create :book
      rental = Rental.create book: book, created_at: created_at

      expect(rental.created_at).to eq created_at
      expect(rental.rental_time).to eq "#{sample} hours"
    end
  end

  it 'return "1 day" for active rentals' do
    created_at = randomize_time_by_minutes 1.day.ago

    book = FactoryGirl.create :book
    rental = Rental.create book: book, created_at: created_at

    expect(rental.created_at).to eq created_at
    expect(rental.rental_time).to eq '1 day'
  end

  it 'return "x days" for active rentals' do
    [*2..6].each do |sample|
      created_at = randomize_time_by_minutes sample.days.ago

      book = FactoryGirl.create :book
      rental = Rental.create book: book, created_at: created_at

      expect(rental.created_at).to eq created_at
      expect(rental.rental_time).to eq "#{sample} days"
    end
  end

  it 'return "1 week" for active rentals' do
    created_at = randomize_time_by_minutes 1.week.ago

    book = FactoryGirl.create :book
    rental = Rental.create book: book, created_at: created_at

    expect(rental.created_at).to eq created_at
    expect(rental.rental_time).to eq '1 week'
  end

  it 'return "x weeks" for active rentals' do
    [*2..4].each do |sample|
      created_at = randomize_time_by_minutes sample.weeks.ago

      book = FactoryGirl.create :book
      rental = Rental.create book: book, created_at: created_at

      expect(rental.created_at).to eq created_at
      expect(rental.rental_time).to eq "#{sample} weeks"
    end
  end

  it 'return "1 month" for active rentals' do
    created_at = randomize_time_by_minutes 1.month.ago
    created_at = created_at - 1.day

    book = FactoryGirl.create :book
    rental = Rental.create book: book, created_at: created_at

    expect(rental.created_at).to eq created_at
    expect(rental.rental_time).to eq '1 month'
  end

  it 'return "x months" for active rentals' do
    active_zone = Time.zone
    Time.zone = 'UTC'

    [*2..11].each do |sample|

      created_at = randomize_time_by_minutes sample.months.ago

      book = FactoryGirl.create :book
      rental = Rental.create book: book, created_at: created_at

      expect(rental.created_at).to eq created_at
      expect(rental.rental_time).to eq "#{sample} months"

    end

    Time.zone = active_zone
  end

  it 'return "1 year" for active rentals' do
    created_at = randomize_time_by_minutes 1.year.ago

    book = FactoryGirl.create :book
    rental = Rental.create book: book, created_at: created_at

    expect(rental.created_at).to eq created_at
    expect(rental.rental_time).to eq '1 year'
  end

  it 'return "x years" for active rentals' do
    active_zone = Time.zone
    Time.zone = 'UTC'

    # We test last 20 years
    [*2..20].each do |sample|

      created_at = randomize_time_by_minutes sample.years.ago

      book = FactoryGirl.create :book
      rental = Rental.create book: book, created_at: created_at

      expect(rental.created_at).to eq created_at
      expect(rental.rental_time).to eq "#{sample} years"

    end

    Time.zone = active_zone
  end

end
