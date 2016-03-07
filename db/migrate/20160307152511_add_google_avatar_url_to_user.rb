class AddGoogleAvatarUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :google_avatar_url, :string
  end
end
