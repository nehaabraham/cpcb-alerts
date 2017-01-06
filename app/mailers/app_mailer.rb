class AppMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to CPCB Alerts')
  end

  def event_reminder(event)
    @event = event
    mail(to: User.pluck(:email),
        subject: "Reminder: #{@event.title}")
  end

end
