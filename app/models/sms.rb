require 'nuntium'

class Sms
  attr_accessor :nuntium

  def self.instance
    @@instance ||= Sms.new
    @@instance
  end

  def send options={}
    options[:from] ||= ENV['APP_NAME']
    options[:to] = options[:to].start_with?("sms://") ? options[:to] : "sms://#{options[:to]}"

    Rails.logger.info("sending sms with options: #{options}")
    nuntium.send_ao(options)
  end

  def nuntium
    @nuntium ||= Nuntium.new(ENV['NUNTIUM_URL'], ENV['NUNTIUM_ACCOUNT'], ENV['NUNTIUM_APP_NAME'], ENV['NUNTIUM_APP_PWD'])
  end

end