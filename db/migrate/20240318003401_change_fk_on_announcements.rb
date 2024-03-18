class ChangeFkOnAnnouncements < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :announcements, column: :googleUserID
    add_foreign_key :announcements, :users, column: :googleUserID, primary_key: :uid, on_delete: :nullify
  end
end
