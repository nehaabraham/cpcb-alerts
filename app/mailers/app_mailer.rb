class AppMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to CPCB Alerts')
  end

  def event_reminder(event)
    @users = User.where(:subscribed_to_email => true)
    @event = event
    mail(to: @users.pluck(:email),
        subject: "Reminder: #{@event.title}")
  end

end
