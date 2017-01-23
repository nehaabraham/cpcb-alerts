class AppMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to CPCB Alerts')
  end

  def event_reminder(event)
    @event = event
    get_email_list(@event.category_id)
    mail(to: @users.pluck(:email),
        subject: "Reminder: #{@event.title}")
  end

  def event_reminder_week(event)
    @event = event
    get_email_list(@event.category_id)
    filter_subscribers('week')
    mail(to: @users.pluck(:email),
        subject: "Reminder: #{@event.title}")
  end

  def event_reminder_day(event)
    @event = event
    get_email_list(@event.category_id)
    filter_subscribers('day')
    mail(to: @users.pluck(:email),
        subject: "Reminder: #{@event.title}")
  end

  private

    def get_email_list(category_id)
      case category_id
      when 1
        @users = User.where(:subscribed_to_email => true, :faculty_meetings => true)
      when 2
        @users = User.where(:subscribed_to_email => true, :cpcb_seminars => true)
      when 3
        @users = User.where(:subscribed_to_email => true, :miscellaneous => true)
      when 4
        @users = User.where(:subscribed_to_email => true, :csb_seminars => true)
      else
       @users = User.all
      end
    end

    def filter_subscribers(subscription_option)
      case subscription_option
      when 'day'
        @users = @users.where(:subscribed_to_email => true, :day_before_email => true)
      when 'week'
        @users = @users.where(:subscribed_to_email => true, :week_before_email => true)
      else
        @users
      end
    end

end
