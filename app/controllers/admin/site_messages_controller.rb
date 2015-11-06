module Admin
  class SiteMessagesController < Controller
    def shipment_messages
      @shipment = Shipment.includes(:site, :site_messages => :site ).find params[:shipment_id]
      @messages = @shipment.site_messages.paginate(paginate_options)
    end

    def all
      @messages  = SiteMessage.includes(:site, :shipment).paginate(paginate_options)
    end
  end

end