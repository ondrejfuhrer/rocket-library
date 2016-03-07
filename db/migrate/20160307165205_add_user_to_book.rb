class AddUserToBook < ActiveRecord::Migration
  def change
    add_reference :books, :user, index: true
  end
end
