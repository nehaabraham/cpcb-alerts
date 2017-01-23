class AddOptionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :day_before_email, :boolean, default: true
    add_column :users, :week_before_email, :boolean, default: true
    change_column :users, :subscribed_to_sms, :boolean,
    default: false
  end
end
