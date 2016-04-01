class Rental < ActiveRecord::Base

  validates_with RentalValidator, on: :create

  state_machine initial: :active do
    event :return do
      transition any => :returned
    end

    before_transition any => :returned do |rental|
      rental.returned_at = Time.now
    end

    after_transition any => :returned do |rental|
      # @type [Rental] rental
      rental.book.release
      rental.watch_lists.active.each do |w|
        UserMailer.watchlist(w.user, rental).deliver_now
      end
    end
  end

  belongs_to :user
  belongs_to :book
  has_many :watch_lists

  default_scope { order('returned_at DESC') }
  scope :active, -> { with_state(:active) }
  scope :returned, -> { with_state(:returned) }

  after_create do
    book.rent
    book.rentals.each do |rental|
      rental.watch_lists.each do |w|
        if w.active?
          if w.user == user
            w.fulfill
            w.save!
          else
            UserMailer.watchlist_unfulfilled(w.user, self).deliver_now
          end
        end
      end
    end
  end

  # Returns a rental time in human readable format. If the rental is still active, the value shows for how long it is rented until now,
  # if the rental is already returned it shows the difference between created time and return time
  #
  # === Return
  # @return [String]
  #
  def rental_time
    from_date = (self.returned? ? self.returned_at : Time.current).utc
    TimeDifference.between(from_date, self.created_at.utc, true).in_general.humanize
  end
end
