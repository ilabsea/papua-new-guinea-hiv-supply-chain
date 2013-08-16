class Sms
  PROVIDER_NUNTIUM = "Nuntium"

  # {:to => address, :body => body, :from => MessageProxy.app_name}

  def self.send_message messages
    nuntium = Nuntium.new_from_config()
    nuntium.send_ao messages
  end
end