# encoding: utf-8
module Admin
  class CommodityCategoriesController < Controller
    load_and_authorize_resource
    def index
      params[:type] = params[:type] || CommodityCategory::TYPES_DRUG
      if(params[:type] == CommodityCategory::TYPES_DRUG)
        @commodity_categories = CommodityCategory.drug.paginate(paginate_options)
      else
        @commodity_categories = CommodityCategory.kit.paginate(paginate_options)
      end
      @app_title = "Commodity Categories"
    end


    def show
      @commodity_category = CommodityCategory.find(params[:id])
      @app_title = "Category :" + @commodity_category.name
    end


    def new
      @commodity_category = CommodityCategory.new(:com_type => params[:type])
      @app_title = "New Category"
    end


    def edit
      @commodity_category = CommodityCategory.find(params[:id])
      @app_title = "Edit: " + @commodity_category.name
    end


    def create
      @commodity_category = CommodityCategory.new(params[:commodity_category])

      if @commodity_category.save
        redirect_to admin_commodity_categories_path(:type =>@commodity_category.com_type ), notice: 'Commodity Category has been created successfully.'
      else
        render action: "new" 
      end

    end


    def update
      @commodity_category = CommodityCategory.find(params[:id])

      if @commodity_category.update_attributes(params[:commodity_category])
        redirect_to admin_commodity_categories_path(:type => @commodity_category.com_type), notice: 'Commodity Category has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @commodity_category = CommodityCategory.find(params[:id])
        @commodity_category.destroy
        redirect_to admin_commodity_categories_path(:type => params[:type]) , :notice => 'Commodity Category has been removed'
      rescue Exception => ex
        redirect_to admin_commodity_categories_path(:type => params[:type]) , :error => ex.message
      end
    end

    def template
      respond_to do |format|
         file_name =  "#{Rails.root}/public/data/template.xls"
         format.xls do 
           Generator::xls file_name
           send_file(file_name , 
                      :filename      =>  "template.xls",
                      :type          =>  'application/xls',
                      :disposition   =>  'attachment',
                      :streaming     =>  true,
                      :buffer_size   =>  '4096')
         end
      end
    end


  end
end