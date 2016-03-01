class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text :name
      t.text :author
      t.text :sku

      t.timestamps null: false
    end
  end
end
