# frozen_string_literal: true

class AddTitleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :title, :string
  end
end
