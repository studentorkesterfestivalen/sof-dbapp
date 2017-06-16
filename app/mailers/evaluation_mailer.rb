class EvaluationMailer < ApplicationMailer
  default from: 'no-reply@sof17.se'

  def evaluation(user)
    @user = user

    mail(to: @user.email, subject: 'SOF17: Utvärdering och Bråvallaerbjudande')
  end
end