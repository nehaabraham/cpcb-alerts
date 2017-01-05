class AppMailer < AsyncMailer
  default from: 'me@nehabraham.com'

  def welcome(user)
    @user = user
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Welcome to CPCB Alerts')
  end

end
