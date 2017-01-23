class AddCompleteToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :ready_to_send, :boolean, default: false
  end
end
