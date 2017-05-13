namespace :orders do
  task send_unsent_receipts: :environment do
    Order.find_each do |order|
      unless order.receipt_sent
        order.send_receipt
      end
    end
  end

  task resend_receipt: :environment do
    # Make sure arguments are collected properly
    ARGV.each { |a| task a.to_sym do ; end}

    if ARGV[1]
      order = Order.find(ARGV[1])
      order.send_receipt
    end
  end
end