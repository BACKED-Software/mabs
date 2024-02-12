class AddSponsorsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :sponsor_title, :string
    add_column :events, :sponsor_description, :text
  end
end
