class Event < ApplicationRecord
  validates :title, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates_date :date, :after => :today
end
