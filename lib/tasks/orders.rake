namespace :orders do
  task send_unsent_receipts: :environment do
    Order.find_each do |order|
      unless order.receipt_sent
        ReceiptMailer.order_receipt(order).deliver_now
        order.receipt_sent = true
        order.save!
      end
    end
  end

  task resend_receipt: :environment do
    # Make sure arguments are collected properly
    ARGV.each { |a| task a.to_sym do ; end}

    if ARGV[1]
      order = Order.find(ARGV[1])
      ReceiptMailer.order_receipt(order).deliver_now
      order.receipt_sent = true
      order.save!
    end
  end
end