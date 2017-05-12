namespace :orders do
  task send_receipts_to_old_orders: :environment do
    Order.find_each do |order|
      unless order.receipt_sent
        ReceiptMailer.order_receipt(order).deliver_now
        order.receipt_sent = true
        order.save!
      end
    end
  end

  task reset_receipt_sent: :environment do
    Order.find_each do |order|
      order.receipt_sent = false
      order.save!
    end
  end
end