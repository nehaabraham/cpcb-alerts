class AddSmsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subscribed_to_sms, :boolean, default: true
  end
end
