
class Event < ApplicationRecord
  belongs_to :category
  # validations
  validates :title, presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates_datetime :start, :on_or_after => DateTime.now
  validates_datetime :end, :on_or_after => :start
  after_save :schedule_email_reminder
  after_save :schedule_sms_reminder


  def when_to_run
    self.start - 1.day
  end

  private

    def schedule_email_reminder
      # if the event is a week or less away, send the
      # email immediately
      if(self.ready_to_send)
        if(self.start <= (DateTime.now + 1.week))
          AppMailer.event_reminder(self, 'now').deliver
        # if the event is more than a week away, schedule the
        # email to one week prior to the event and
        # one day prior to the event
        else
          AppMailer.event_reminder(self, 'week').deliver_later(wait_until: self.start - 1.week)
          AppMailer.event_reminder(self, 'day').deliver_later(wait_until: self.start - 1.day)
        end
      end
    end

    # schedule an SMS reminder using Twilio
    # use delayed_job to schedule the email
    def schedule_sms_reminder
      if(self.ready_to_send)
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
    end

    handle_asynchronously :schedule_sms_reminder, :run_at => Proc.new { |i| i.when_to_run }

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
