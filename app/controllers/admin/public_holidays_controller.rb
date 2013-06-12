module Admin
  class PublicHolidaysController < ApplicationController
    def index
      @public_holidays = PublicHoliday.paginate(paginate_options)
      @app_title = "Public holidays"
    end

    def show
      @public_holiday = PublicHoliday.find(params[:id])
      @app_title = "Holiday: #{@public_holiday.name}"
    end

    def new
      @public_holiday = PublicHoliday.new
      @app_title = "New Public holiday"
    end

    # GET /public_holidays/1/edit
    def edit
      @public_holiday = PublicHoliday.find(params[:id])
      @app_title = "Holiday: #{@public_holiday.name}"
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
      begin
        @public_holiday = PublicHoliday.find(params[:id])
        @public_holiday.destroy
        redirect_to admin_public_holidays_url, :notice => "Holiday has been removed"
      rescue Exception => ex
        redirect_to admin_public_holidays_url, :error => ex.message
      end
    end
  end
end
