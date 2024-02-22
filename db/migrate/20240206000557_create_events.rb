# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.text :eventLocation
      t.text :eventInfo
      t.string :eventName
      t.datetime :eventTime
      t.integer :eventPoints

      t.timestamps
    end
  end
end
