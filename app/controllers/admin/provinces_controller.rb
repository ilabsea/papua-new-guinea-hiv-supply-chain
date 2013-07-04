module Admin
  class ProvincesController < Controller
    # GET /provinces
    # GET /provinces.json
    def index
      @provinces = Province.paginate(paginate_options)
      @app_title = "Provinces"
    end

    # GET /provinces/1
    # GET /provinces/1.json
    def show
      @province = Province.find(params[:id])
      @app_title = "Province: #{@province.name}"
    end

    # GET /provinces/new
    # GET /provinces/new.json
    def new
      @province = Province.new
      @app_title = "New Province"
    end

    # GET /provinces/1/edit
    def edit
      @province  = Province.find(params[:id])
      @app_title = "Edit: #{@province.name}" 
    end

    # POST /provinces
    # POST /provinces.json
    def create
      @province = Province.new(params[:province])
      if @province.save
        redirect_to admin_provinces_path, notice: 'Province has been created successfully.'
      else
        render action: "new" 
      end
    end

    # PUT /provinces/1
    # PUT /provinces/1.json
    def update
      @province = Province.find(params[:id])
      if @province.update_attributes(params[:province])
        redirect_to admin_provinces_path, notice: 'Province has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    # DELETE /provinces/1
    # DELETE /provinces/1.json
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

