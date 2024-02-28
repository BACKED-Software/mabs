class AddForeignKeyToAnnouncements < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :uid, unique: true
    add_foreign_key :announcements, :users, column: :googleUserID, primary_key: :uid
  end
end
