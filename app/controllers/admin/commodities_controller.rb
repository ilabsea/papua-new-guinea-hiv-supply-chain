module Admin
  class CommoditiesController < Controller
    load_and_authorize_resource
    def index
        @commodities = Commodity.includes(:commodity_category, :regimen, :lab_test)

        params[:type] = params[:type] || CommodityCategory::TYPES_DRUG
        if (params[:type] ==  CommodityCategory::TYPES_DRUG)
          @commodities = @commodities.where("commodity_categories.com_type = ?", CommodityCategory::TYPES_DRUG)
        elsif (params[:type] == CommodityCategory::TYPES_KIT)
          @commodities = @commodities.where("commodity_categories.com_type = ?", CommodityCategory::TYPES_KIT)
        end
        @commodities = @commodities.paginate(paginate_options)
    end

    def new
      @commodity = Commodity.new(commodity_type: params[:type])
    end

    def edit
      @commodity = Commodity.find(params[:id])
      @commodity.commodity_type = params[:type]
    end

    def create
      @commodity = Commodity.new(params[:commodity])
      if @commodity.save
        redirect_to admin_commodities_path(:type => params[:type]), notice: 'Commodity has been created successfully.'
      else
        render action: "new" 
      end
    end

    # PUT /commodities/1
    # PUT /commodities/1.json
    def update
      @commodity = Commodity.find(params[:id])
      if @commodity.update_attributes(params[:commodity])
        redirect_to admin_commodities_path(:type => params[:type]), notice: 'Commodity has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    # DELETE /commodities/1
    # DELETE /commodities/1.json
    def destroy
      begin
        @commodity = Commodity.find(params[:id])
        @commodity.destroy
        redirect_to admin_commodities_url(:type => params[:type]), :notice => "Commodity has been removed" 
      rescue Exception => e
        redirect_to admin_commodities_url, :error => e.message         
      end
      
    end
  end
end