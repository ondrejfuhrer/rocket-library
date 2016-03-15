require 'rails_helper'

RSpec.describe Rental do
  context '#validate' do
    it 'should have no errors when book not rented' do
      book = Book.new state: :active, sku: 'test-sku'
      record = Rental.new book: book

      validator = RentalValidator.new
      validator.validate record

      expect(record.errors.count).to eq 0
      expect(record.errors[:base].count).to eq 0
    end

    it 'should have error when book rented' do
      book = Book.new state: :rented, sku: 'test-sku'
      record = Rental.new book: book

      validator = RentalValidator.new
      validator.validate record

      expect(record.errors.count).to eq 1
      expect(record.errors[:base].count).to eq 1
    end
  end
end
