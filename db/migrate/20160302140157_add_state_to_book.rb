class AddStateToBook < ActiveRecord::Migration
  def change
    change_table :books do |t|
      t.string :state
    end
  end
end
