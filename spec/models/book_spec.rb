require 'rails_helper'

RSpec.describe Book do
  context '.after_create' do
    it 'set SKU as ID' do
      book = Book.new name: FFaker::Lorem.words(3), author: FFaker::Name.name, sku: nil
      book.save!

      expect(book.sku).to eq book.id.to_s
    end
  end
end
