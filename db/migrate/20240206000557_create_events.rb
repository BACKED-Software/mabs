class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.text :eventLocation
      t.text :eventInfo
      t.string :eventName
      t.datetime :eventTime

      t.timestamps
    end
  end
end

class AddSponsorDetailsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :sponsor_title, :string
    add_column :events, :sponsor_description, :text
  end
end

