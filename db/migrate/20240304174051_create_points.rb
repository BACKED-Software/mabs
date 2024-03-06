# frozen_string_literal: true

class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.integer :numPointsAwarded
      t.string :awardedBy
      t.string :awardedTo
      t.datetime :dateOfAward
      t.text :awardDescription

      t.timestamps
    end
  end
end
