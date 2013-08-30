class Service::MessagingsController < Service::Controller

    before_filter :authenticate_nuntium, :only => [:nuntium, :nuntium_ack]

    def nuntium
      render :json => params
    end

    def nuntium_ack
      render :json => params
    end

    private

    def authenticate_nuntium
      nuntium_config = NuntiumMessagingAdapter.instance.config
      authenticate_or_request_with_http_basic do |username, password|
        username == nuntium_config['incoming_username'] && password == nuntium_config['incoming_password']
      end
    end
end
