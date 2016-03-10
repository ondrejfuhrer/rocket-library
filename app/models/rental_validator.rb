class RentalValidator < ActiveModel::Validator
  def validate(record)
    if record.book.rented?
      record.errors[:base] << I18n.t('rental.error.already_rented', { sku: record.book.sku })
    end
  end
end