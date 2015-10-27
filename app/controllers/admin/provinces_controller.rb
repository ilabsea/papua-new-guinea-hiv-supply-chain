module Admin
  class ProvincesController < Controller
    load_and_authorize_resource
    def index
      @provinces = Province.order('name').paginate(paginate_options)
    end

    def show
      @province = Province.find(params[:id])
    end

    def new
      @province = Province.new
    end


    def edit
      @province  = Province.find(params[:id])
    end

    def create
      @province = Province.new(params[:province])
      if @province.save
        redirect_to admin_provinces_path, notice: 'Province has been created successfully.'
      else
        render action: "new" 
      end
    end

    def update
      @province = Province.find(params[:id])
      if @province.update_attributes(params[:province])
        redirect_to admin_provinces_path, notice: 'Province has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @province = Province.find(params[:id])
        @province.destroy
        redirect_to admin_provinces_url, :notice => "Province has been removed" 
      rescue Exception => e
        redirect_to admin_provinces_url, :error =>  e.message 
      end
    end
  end
end

