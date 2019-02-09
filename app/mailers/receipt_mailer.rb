class ReceiptMailer < ApplicationMailer
  default from: 'no-reply@sof.lintek.nu'

  def order_receipt(order)
    @user = order.user
    @order = order
    @total = order.order_items.sum { |x| x.cost } - order.rebate - order.funkis_rebate

    mail(to: @user.email, subject: 'SOF19: Kvitto för order')
  end
end
