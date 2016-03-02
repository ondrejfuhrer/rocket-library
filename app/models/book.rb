class Book < ActiveRecord::Base
  validates_presence_of :name, :author, :sku
end
