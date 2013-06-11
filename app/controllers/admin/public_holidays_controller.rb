module Admin
  class PublicHolidaysController < ApplicationController
    # GET /public_holidays
    # GET /public_holidays.json
    def index
      @public_holidays = PublicHoliday.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @public_holidays }
      end
    end

    # GET /public_holidays/1
    # GET /public_holidays/1.json
    def show
      @public_holiday = PublicHoliday.find(params[:id])
    end

    # GET /public_holidays/new
    # GET /public_holidays/new.json
    def new
      @public_holiday = PublicHoliday.new
    end

    # GET /public_holidays/1/edit
    def edit
      @public_holiday = PublicHoliday.find(params[:id])
    end

    # POST /public_holidays
    # POST /public_holidays.json
    def create
      @public_holiday = PublicHoliday.new(params[:public_holiday])

      if @public_holiday.save
        redirect_to admin_public_holiday_path(@public_holiday), notice: 'Public Holiday was successfully created.'
      else
        render action: "new" 
      end
    end

    # PUT /public_holidays/1
    # PUT /public_holidays/1.json
    def update
      @public_holiday = PublicHoliday.find(params[:id])

      if @public_holiday.update_attributes(params[:public_holiday])
        redirect_to admin_public_holiday_path(@public_holiday), notice: 'Province was successfully updated.' 
      else
        render action: "edit" 
      end
    end

    # DELETE /public_holidays/1
    # DELETE /public_holidays/1.json
    def destroy
      @public_holiday = PublicHoliday.find(params[:id])
      @public_holiday.destroy

      redirect_to admin_public_holidays_url 
    end
  end
end
