class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.references :user
      t.references :book
      t.string :state

      t.timestamps null: false
    end
  end
end
