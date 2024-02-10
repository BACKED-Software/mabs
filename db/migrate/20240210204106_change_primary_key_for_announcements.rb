class ChangePrimaryKeyForAnnouncements < ActiveRecord::Migration[7.0]
  def change
    # Remove the existing primary key
    remove_column :announcements, :id
    remove_column :announcements, :announcementID

    # Add the announcementID column as primary key
    add_column :announcements, :announcementID, :bigserial, primary_key: true
  end
end
