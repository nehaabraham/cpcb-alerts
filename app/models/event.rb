
class Event < ApplicationRecord
  belongs_to :category
  # validations
  validates :title, presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates_datetime :start, :on_or_after => DateTime.now
  validates_datetime :end, :on_or_after => :start
  after_create :check_ready
  after_update :delete_and_reschedule
  before_destroy :delete_jobs


  def run_one_day
    self.start - 1.day
  end

  def run_one_week
    self.start - 1.week
  end

  private

    def check_ready
      if(self.ready_to_send)
        schedule_email_reminder
        schedule_sms_reminder
      end
    end

    def schedule_email_reminder

      if(self.start <= (DateTime.now + 1.week))
        # if the event a week away, send the email immediately
        send_email_now
      else
        # if the event is more than a week away, schedule the
        # email to one week prior to the event and
        # one day prior to the event
        send_email_one_week
        send_email_one_day
      end

    end

    # schedule an SMS reminder using Twilio
    # use delayed_job to schedule the sms
    def schedule_sms_reminder
      @twilio_number = ENV['TWILIO_NUMBER']
      @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      users = get_sms_list
      users.each do |user|
        reminder = "DCB Reminder: Don't forget! #{self.title} on #{self.start.to_formatted_s(:long_ordinal)} at #{self.location}"
        message = @client.account.messages.create(
          :from => @twilio_number,
          :to => user.phone,
          :body => reminder,
        )
      end

    end
    handle_asynchronously :schedule_sms_reminder, :run_at => Proc.new { |i| i.run_one_day }

    # get list of users to send sms based on
    # event category and subscription settings
    def get_sms_list
      if(self.category_id == 1)
        users = User.where(:subscribed_to_sms => true, :faculty_meetings => true)
      elsif(self.category_id == 2)
        users = User.where(:subscribed_to_sms => true, :cpcb_seminars => true)
      elsif(self.category_id == 3)
        users = User.where(:subscribed_to_sms => true, :miscellaneous => true)
      elsif(self.category_id == 4)
        users = User.where(:subscribed_to_sms => true, :csb_seminars => true)
      else
        users = User.all
      end
    end

    # Email scheduling

    def send_email_now
      AppMailer.event_reminder(self, 0).deliver
    end

    def send_email_one_day
      AppMailer.event_reminder(self, 1).deliver
    end
    handle_asynchronously :send_email_one_day, :run_at => Proc.new { |i| i.run_one_day }

    def send_email_one_week
      AppMailer.event_reminder(self, 2).deliver
    end
    handle_asynchronously :send_email_one_week, :run_at => Proc.new { |i| i.run_one_week }

    # Delete old jobs
    def delete_and_reschedule
      delete_jobs

      # re-schedule jobs
      check_ready
    end

    def delete_jobs
      # Iterate through delayed_job table and find jobs for event, remove jobs and create new if ready_to_send

      Delayed::Job.all.each do |job|
        handler_string = job.handler #handler contains all event information
        temp_arr1 = handler_string.split("id: ") #isolate the event id, will be in temp_arr1[1]
        temp_arr2 = temp_arr1[1].split("\n") #remove trailing string
        event_id = temp_arr2[0].to_i - 1 #off by one
        if(self.id == event_id)
          job.destroy
        end
      end
    end


end
