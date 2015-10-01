module Admin
  class SiteMessagesController < Controller
    def shipment_messages
      @shipment = Shipment.includes(:site, :site_messages => :site ).find params[:shipment_id]
      @messages = @shipment.site_messages.paginate(paginate_options)
      @app_title = "#{@shipment.consignment_number} - messages"
    end

    def all
      @messages  = SiteMessage.includes(:site, :shipment).paginate(paginate_options)
      @app_title = "Messages from sites" 
    end
  end

end