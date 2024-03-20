# frozen_string_literal: true

class AddForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :attendances, :users, column: :googleUserID, primary_key: :uid
    add_foreign_key :attendances, :events, column: :eventID, primary_key: :id
  end
end
