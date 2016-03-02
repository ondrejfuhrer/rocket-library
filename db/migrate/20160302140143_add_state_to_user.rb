class AddStateToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :state
    end
  end
end
