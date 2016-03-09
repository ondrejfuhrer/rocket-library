class AddReturnMessageToRental < ActiveRecord::Migration
  def change
    add_column :rentals, :return_message, :text
  end
end
