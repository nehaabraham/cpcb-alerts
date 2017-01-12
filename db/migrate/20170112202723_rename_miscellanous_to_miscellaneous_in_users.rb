class RenameMiscellanousToMiscellaneousInUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :miscellanous, :miscellaneous
  end
end
