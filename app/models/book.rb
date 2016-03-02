class Book < ActiveRecord::Base
  validates_presence_of :name, :author, :sku
  validates_uniqueness_of :sku
end
