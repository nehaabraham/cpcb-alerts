
class Event < ApplicationRecord
  belongs_to :category
  # validations
  validates :title, presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :category_id, presence: true
  validates_datetime :start, :on_or_after => DateTime.now
  validates_datetime :end, :on_or_after => :start
  # sending reminders after creation
  after_create :send_email_reminder
  after_create :send_sms_reminder


  def when_to_run
    self.start - 1.day
  end

  private

    def send_email_reminder
      # if the event is a week or less away, send the email immediately
      if(self.start <= (DateTime.now + 1.week))
        AppMailer.event_reminder(self).deliver
      # if the event is more than a week away, send the reminder email one week prior to the event
      else
        AppMailer.event_reminder(self).deliver_later(wait_until: self.start - 1.week)
      end
    end

    def send_sms_reminder
      @twilio_number = ENV['TWILIO_NUMBER']
      @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      @users = get_sms_list
      @users.each do |user|
        reminder = "DCB Reminder: Don't forget! #{self.title} on #{self.start.to_formatted_s(:long_ordinal)} at #{self.location}"
        message = @client.account.messages.create(
          :from => @twilio_number,
          :to => user.phone,
          :body => reminder,
        )
      end
    end

    handle_asynchronously :send_sms_reminder, :run_at => Proc.new { |i| i.when_to_run }

    # get list of users to send sms based on
    # event category and subscription settings
    def get_sms_list
      case self.category_id
      when 1
        @users = User.where(:subscribed_to_sms => true, :faculty_meetings => true)
      when 2
        @users = User.where(:subscribed_to_sms => true, :cpcb_seminars => true)
      when 3
        @users = User.where(:subscribed_to_sms => true, :miscellaneous => true)
      when 4
        @users = User.where(:subscribed_to_sms => true, :csb_seminars => true)
      else
        @users = User.all
      end
    end

end
