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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @public_holiday }
    end
  end

  # GET /public_holidays/new
  # GET /public_holidays/new.json
  def new
    @public_holiday = PublicHoliday.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @public_holiday }
    end
  end

  # GET /public_holidays/1/edit
  def edit
    @public_holiday = PublicHoliday.find(params[:id])
  end

  # POST /public_holidays
  # POST /public_holidays.json
  def create
    @public_holiday = PublicHoliday.new(params[:public_holiday])

    respond_to do |format|
      if @public_holiday.save
        format.html { redirect_to @public_holiday, notice: 'Public holiday was successfully created.' }
        format.json { render json: @public_holiday, status: :created, location: @public_holiday }
      else
        format.html { render action: "new" }
        format.json { render json: @public_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /public_holidays/1
  # PUT /public_holidays/1.json
  def update
    @public_holiday = PublicHoliday.find(params[:id])

    respond_to do |format|
      if @public_holiday.update_attributes(params[:public_holiday])
        format.html { redirect_to @public_holiday, notice: 'Public holiday was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @public_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /public_holidays/1
  # DELETE /public_holidays/1.json
  def destroy
    @public_holiday = PublicHoliday.find(params[:id])
    @public_holiday.destroy

    respond_to do |format|
      format.html { redirect_to public_holidays_url }
      format.json { head :no_content }
    end
  end
end
