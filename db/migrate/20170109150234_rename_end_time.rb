class RenameEndTime < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :end_time, :end
    rename_column :events, :datetime, :start
  end
end
