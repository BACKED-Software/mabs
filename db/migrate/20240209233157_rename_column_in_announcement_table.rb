# frozen_string_literal: true

class RenameColumnInAnnouncementTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :announcements, :googleUsedID, :googleUserID
  end
end
