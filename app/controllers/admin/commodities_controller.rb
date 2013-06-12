module Admin
  class CommoditiesController < ApplicationController
    # GET /commodities
    # GET /commodities.json
    def index
      @commodities = Commodity.paginate(paginate_options)
    end

    # GET /commodities/1
    # GET /commodities/1.json
    def show
      @commodity = Commodity.find(params[:id])
    end

    # GET /commodities/new
    # GET /commodities/new.json
    def new
      @commodity = Commodity.new
    end

    # GET /commodities/1/edit
    def edit
      @commodity = Commodity.find(params[:id])
    end

    # POST /commodities
    # POST /commodities.json
    def create
      @commodity = Commodity.new(params[:commodity])
      if @commodity.save
        redirect_to admin_commodity_path(@commodity), notice: 'Commodity was successfully created.'
      else
        render action: "new" 
      end
    end

    # PUT /commodities/1
    # PUT /commodities/1.json
    def update
      @commodity = Commodity.find(params[:id])
      if @commodity.update_attributes(params[:commodity])
        redirect_to admin_commodity_path(@commodity), notice: 'Commodity was successfully updated.' 
      else
        render action: "edit" 
      end
    end

    # DELETE /commodities/1
    # DELETE /commodities/1.json
    def destroy
      @commodity = Commodity.find(params[:id])
      @commodity.destroy
      redirect_to admin_commodities_url 
    end
  end
end