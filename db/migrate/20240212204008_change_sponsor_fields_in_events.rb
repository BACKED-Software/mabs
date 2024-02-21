# frozen_string_literal: true

class ChangeSponsorFieldsInEvents < ActiveRecord::Migration[7.0]
  def change
    change_column_null :events, :sponsor_title, true
    change_column_null :events, :sponsor_description, true
  end
end
