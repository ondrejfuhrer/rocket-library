class Book < ActiveRecord::Base
  validates_presence_of :name, :author

  default_scope { without_states(:deleted).order(:name) }

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

  after_create do |book|
    book.update(sku: book.id) if book.sku.blank?
  end

end
