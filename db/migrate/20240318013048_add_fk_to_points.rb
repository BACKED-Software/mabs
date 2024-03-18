class AddFkToPoints < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :points, :users, column: :awardedTo, primary_key: :uid, on_delete: :cascade
  end
end
