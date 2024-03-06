# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :email,              null: false
      t.boolean :is_admin,          default: false
      t.string :full_name
      t.string :middle_initial, limit: 1
      t.string :gender
      t.boolean :is_hispanic_or_latino
      t.string :race
      t.boolean :is_us_citizen
      t.boolean :is_first_generation_college_student
      t.datetime :date_of_birth
      t.string :phone_number
      t.string :avatar_url
      t.text :bio
      t.string :classification
      t.integer :total_points

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
