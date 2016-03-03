class RentalValidator < ActiveModel::Validator
  def validate(record)
    if record.book.rented?
      record.errors[:base] << "Book with SKU [#{record.book.sku}] has been already rented!"
    end
  end
end