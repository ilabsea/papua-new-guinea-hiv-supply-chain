# encoding: utf-8
module Admin
  class RegimenCategoriesController < Controller
    load_and_authorize_resource

    def index
      @categories = RegimenCategory.paginate(paginate_options)
    end

    def new
      @category = RegimenCategory.new
    end


    def edit
      @category = RegimenCategory.find(params[:id])
    end

    def create
      @category = RegimenCategory.new(params[:regimen_category])

      if @category.save
        redirect_to admin_regimen_categories_path, notice: 'Regimen Category has been created successfully.'
      else
        render action: "new" 
      end
    end

    def update
      @category = RegimenCategory.find(params[:id])

      if @category.update_attributes(params[:regimen_category])
        redirect_to admin_regimen_categories_path, notice: 'Regimen Category has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @category = RegimenCategory.find(params[:id])
        @category.destroy
        redirect_to admin_regimen_categories_path , :notice => 'Regimen Category has been removed'
      rescue Exception => ex
        redirect_to admin_regimen_categories_path , :error => ex.message
      end
    end

  end
end