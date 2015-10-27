# encoding: utf-8
module Admin
  class RegimensController < Controller
    load_and_authorize_resource

    def index
      @regimens = Regimen.includes(:regimen_category, :unit).order('name').paginate(paginate_options)
    end

    def new
      @regimen = Regimen.new
    end


    def edit
      @regimen = Regimen.find(params[:id])
    end

    def create
      @regimen = Regimen.new(params[:regimen])

      if @regimen.save
        redirect_to admin_regimens_path, notice: 'Regimen has been created successfully.'
      else
        render action: "new" 
      end
    end

    def update
      @regimen = Regimen.find(params[:id])

      if @regimen.update_attributes(params[:regimen])
        redirect_to admin_regimens_path, notice: 'Regimen has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @regimen = Regimen.find(params[:id])
        @regimen.destroy
        redirect_to admin_regimens_path , :notice => 'Regimen has been removed'
      rescue Exception => ex
        redirect_to admin_regimens_path , :error => ex.message
      end
    end

  end
end