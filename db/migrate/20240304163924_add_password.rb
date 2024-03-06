# frozen_string_literal: true

class AddPassword < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :password, :string
  end
end
