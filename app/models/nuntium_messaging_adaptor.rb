require 'nuntium'

class NuntiumMessagingAdaptor < MessagingAdaptor
	
  attr_accessor :nuntium

  def nuntium
  	@nuntium
  end

  def nuntium=(nt)
  	@nuntium = nt
  end	

  def config
    @config
  end

  def initialize
    config_file = File.expand_path('config/nuntium.yml', Rails.root)
  	@config   = YAML.load_file(config_file)[Rails.env]
  	@nuntium = Nuntium.new(@config['url'], @config['account'], @config['application'], @config['password'])
  end

 
  def self.instance
  	@@instance ||= NuntiumMessagingAdaptor.new
  end
  NuntiumMessagingAdaptor.instance
  private_class_method :new

  def send  options
    options[:country] =   @config[:country]
    options[:suggested_channel] =  @config[:suggested_channel] 

  	nuntium.send_ao(options)
  end

  def channels
    @nuntium.channels
  end
    
end
