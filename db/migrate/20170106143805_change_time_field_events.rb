class ChangeTimeFieldEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :time
    add_column :events, :datetime, :datetime
  end
end
