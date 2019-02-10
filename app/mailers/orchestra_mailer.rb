class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@sof.lintek.nu'
  layout 'mailer'

  def orchestra_invitation_mailer(orchestra)
    @orchestra = orchestra
    mail(to: @orchestra.email, subject: t(.subject))
  end
end
