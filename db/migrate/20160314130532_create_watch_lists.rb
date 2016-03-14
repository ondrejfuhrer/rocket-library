class CreateWatchLists < ActiveRecord::Migration
  def change
    create_table :watch_lists do |t|
      t.references :rental
      t.references :user
      t.text :state

      t.timestamps null: false
    end
  end
end
