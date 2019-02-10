class OrchestraMailer < ApplicationMailer
  default from: 'no-reply@sof.lintek.nu'

  def orchestra_invitation(orchestra)
    @orchestra = orchestra
    mail(to: @orchestra.email, subject: "SOF 2019 Linköping")
  end
end
