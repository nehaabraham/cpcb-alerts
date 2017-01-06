class AppMailer < ApplicationMailer
  default from: 'neha.abraham.pitt@gmail.com'

  def welcome(user)
    @user = user
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Welcome to CPCB Alerts')
  end

  def event_reminder(event)
    @event = event
    mail(to: User.pluck(:email),
        subject: "Reminder: #{@event.title}")
  end

end
