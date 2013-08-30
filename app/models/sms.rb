
# sms = Sms.new adaptor do |sms|
#     sms.body = "hello nuntium"
#     sms.to  = "011819281"
#     sms.from = "0975553553"
# end
# 
# sms.send adaptor
# 
# 
# 3: send directly old from
# sms = Sms.send do |sms|
#     sms.from = "011999999"
#     sms.to = "097999999"
#     sms.body = "hello"
# end
# sms.to_hash
# 
# 4: send directly
# 
# sms = Sms.send do 
#     from = "011999999"
#     to   = "097999999"
#     body = "hello"
# end
#
module SmsMod
  attr_accessor :from, :to, :body

  def send_via_adaptor adaptor
    adaptor.send to_hash
  end

  def log
    Rails.logger.info "Logging Sms message @#{Time.now} "
    Rails.logger.info ":from => #{from}, :to => #{to}, :body => #{body}"
  end

  def to_hash
    { :from => @from, :to =>@to, :body => @body }
  end

  def send adaptor, &block
    if block_given? && block.arity == 1 # pass an argurment that is a class instance
      yield(self)
    end
    send_via_adaptor adaptor
    log
  end
  
end

class Sms
  include SmsMod 
  extend SmsMod
  
  def initialize &block
    if block_given? && block.arity == 1 # pass an argurment that is a class instance
      yield(self)
    end
  end

  # class << self
  #   include SmsMod
  # end
end

