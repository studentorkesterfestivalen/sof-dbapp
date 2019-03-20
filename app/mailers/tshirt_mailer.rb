class TshirtMailer < ApplicationMailer
  default from: 'no-reply@sof.lintek.nu'

  def tshirt_sizes(user)
    @user = user
    mail(to: @user.email, subject: "SOF19: T-Shirt Size")
  end
end
