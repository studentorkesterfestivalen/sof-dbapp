class FaultReport
  LINE_BEGIN = "\tfrom "
  LINE_END = "\n"

  attr_reader :message

  def initialize(message, stack: nil)
    @message = message
    @stack = stack || caller(1)
  end

  def stack
    LINE_BEGIN + @stack.join(LINE_END + LINE_BEGIN)
  end

  def send
    FaultMailer.fault_mail(self).deliver_now
  end

  def self.send(*args)
    FaultReport.new(*args, stack: caller(1)).send
  end
end