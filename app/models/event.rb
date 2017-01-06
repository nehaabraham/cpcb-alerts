class Event < ApplicationRecord
  validates :title, presence: true
  validates :datetime, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates_datetime :datetime, :on_or_after => DateTime.now
  after_save :send_reminder

  private

    def send_reminder
      # if the event is a week or less away, send the email immediately
      if(self.datetime <= (DateTime.now + 1.week))
        AppMailer.event_reminder(self).deliver
      # if the event is more than a week away, send the reminder email one week prior to the event
      else
        AppMailer.event_reminder(self).deliver_later(wait_until: self.datetime - 1.week)
      end
    end
end
