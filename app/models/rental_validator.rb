class RentalValidator < ActiveModel::Validator

  # This validator checks if we are not trying to rent already rented book
  #
  # === Parameters
  # @param [Rental] record
  #
  def validate(record)
    if record.book.rented?
      record.errors[:base] << I18n.t('rental.error.already_rented', { sku: record.book.sku })
    end
  end
end