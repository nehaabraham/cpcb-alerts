class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.date :date
      t.time :time
      t.string :location
      t.text :description
      t.timestamps
    end
  end
end
