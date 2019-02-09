class EvaluationMailer < ApplicationMailer
  default from: 'no-reply@sof.lintek.nu'

  def evaluation(user)
    mail(to: user.email, subject: 'SOF17: Utvärdering och Bråvallaerbjudande')
  end
end
