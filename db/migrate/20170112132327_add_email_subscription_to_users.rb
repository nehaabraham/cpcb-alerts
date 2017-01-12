class AddEmailSubscriptionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subscribed_to_email, :boolean, default: true
  end
end
