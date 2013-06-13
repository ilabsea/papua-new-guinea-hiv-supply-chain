module Admin
  class CommodityCategoriesController < Controller
    
    def index
      @commodity_categories = CommodityCategory.paginate(paginate_options)
      @app_title = "Commodity Categories"
    end


    def show
      @commodity_category = CommodityCategory.find(params[:id])
      @app_title = "Category :" + @commodity_category.name
    end


    def new
      @commodity_category = CommodityCategory.new
      @app_title = "New Category"
    end


    def edit
      @commodity_category = CommodityCategory.find(params[:id])
      @app_title = "Edit: " + @commodity_category.name
    end


    def create
      @commodity_category = CommodityCategory.new(params[:commodity_category])

      if @commodity_category.save
        redirect_to admin_commodity_category_path(@commodity_category), notice: 'Commodity Category was successfully created.'
      else
        render action: "new" 
      end

    end


    def update
      @commodity_category = CommodityCategory.find(params[:id])

      if @commodity_category.update_attributes(params[:commodity_category])
        redirect_to admin_commodity_category_path(@commodity_category), notice: 'Commodity Category was successfully updated.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @commodity_category = CommodityCategory.find(params[:id])
        @commodity_category.destroy
        redirect_to admin_commodity_categories_url , :notice => 'Commodity Category has been removed'
      rescue Exception => ex
        redirect_to admin_commodity_categories_url , :error => ex.message
      end
      
      
    end
  end
end