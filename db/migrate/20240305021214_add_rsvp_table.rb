# frozen_string_literal: true

class AddRsvpTable < ActiveRecord::Migration[7.0]
  def change
    create_table :rsvps do |t|
      t.string :user_uid
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    add_foreign_key :rsvps, :users, column: :user_uid, primary_key: 'uid', on_delete: :cascade
  end
end
