class FaultMailer < ApplicationMailer
  default to: 'itutskottet@sof17.se',
          from: 'no-reply@sof17.se'

  def fault_mail(report)
    @report = report
    mail(subject: "ERROR: #{report.message}")
  end
end
