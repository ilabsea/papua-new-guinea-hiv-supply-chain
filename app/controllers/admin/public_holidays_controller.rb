module Admin
  class PublicHolidaysController < Controller
    load_and_authorize_resource
    def index
      @public_holidays = PublicHoliday.order('date').paginate(paginate_options)
    end

    def show
      @public_holiday = PublicHoliday.find(params[:id])
    end

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
        redirect_to admin_public_holidays_path, notice: 'Public Holiday has been created successfully.'
      else
        render action: "new" 
      end
    end

    # PUT /public_holidays/1
    # PUT /public_holidays/1.json
    def update
      @public_holiday = PublicHoliday.find(params[:id])

      if @public_holiday.update_attributes(params[:public_holiday])
        redirect_to admin_public_holidays_path, notice: 'Public Holiday has been updated successfully.' 
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
