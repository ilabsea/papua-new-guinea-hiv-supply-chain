module Admin
  class ShipmentsController < Controller
    def index
      @shipments = Shipment.paginate(paginate_options)
    end 

  end
end

