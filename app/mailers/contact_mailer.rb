class ContactMailer < ActionMailer::Base
  default from: "from@example.com"
  def welcome_email(name, email, subject, content)
    @name = name
    @email = email
    @subject = subject
    @content = content
    @url = 'http://example.com/Login'
    mail(to: "bobbyho0064@gmail.com", subject: @subject)
  end
end
