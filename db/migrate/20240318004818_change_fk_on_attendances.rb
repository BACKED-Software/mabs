# frozen_string_literal: true

class ChangeFkOnAttendances < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :attendances, column: :googleUserID
    add_foreign_key :attendances, :users, column: :googleUserID, primary_key: :uid, on_delete: :nullify
  end
end
