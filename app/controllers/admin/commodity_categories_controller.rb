# encoding: utf-8
module Admin
  class CommodityCategoriesController < Controller
    load_and_authorize_resource
    skip_load_resource :only => [:template]
    skip_authorize_resource :only => [:template]

    def index
      params[:type] = params[:type] || CommodityCategory::TYPES_DRUG
      if(params[:type] == CommodityCategory::TYPES_DRUG)
        @commodity_categories = CommodityCategory.drug.order('name').paginate(paginate_options)
      else
        @commodity_categories = CommodityCategory.kit.order('name').paginate(paginate_options)
      end
    end

    def new
      @commodity_category = CommodityCategory.new(:com_type => params[:type])
    end


    def edit
      @commodity_category = CommodityCategory.find(params[:id])
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