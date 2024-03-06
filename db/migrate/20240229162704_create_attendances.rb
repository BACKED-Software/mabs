# frozen_string_literal: true

class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.integer :eventID, foreign_key: true
      t.text :googleUserID, foreign_key: true
      t.datetime :timeOfCheckIn
      t.integer :pointsAwarded

      t.timestamps
    end
  end
end
