class AddSubscriptionOptionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :faculty_meetings, :boolean, default: true
    add_column :users, :cpcb_seminars, :boolean, default: true
    add_column :users, :csb_seminars, :boolean, default: true
    add_column :users, :miscellanous, :boolean, default: true
  end
end
