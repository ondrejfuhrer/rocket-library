class Book < ActiveRecord::Base
  validates_presence_of :name, :author, :sku
  validates_uniqueness_of :sku

  default_scope { without_states(:deleted) }

  state_machine initial: :active do
    event :remove do
      transition :active => :deleted
    end

    event :rent do
      transition :active => :rented
    end

    event :release do
      transition :rented => :active
    end
  end

  mount_uploader :cover, BookCoverUploader
  has_many :rentals
  belongs_to :user

end
