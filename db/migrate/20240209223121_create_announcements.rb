class CreateAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :announcements do |t|
      t.integer :announcementID
      t.string :googleUsedID
      t.text :subject
      t.datetime :dateOfAnnouncement
      t.text :body

      t.timestamps
    end
  end
end
