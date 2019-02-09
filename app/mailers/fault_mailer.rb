class FaultMailer < ApplicationMailer
  default to: 'it@sof.lintek.nu',
          from: 'no-reply@sof.lintek.nu'

  def fault_mail(report)
    @report = report
    mail(subject: "ERROR: #{report.message}")
  end
end
