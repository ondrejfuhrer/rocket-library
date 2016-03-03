class AddReturnedAtToRental < ActiveRecord::Migration
  def change
    add_column :rentals, :returned_at, :timestamp
  end
end
