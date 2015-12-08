# encoding: utf-8
module Admin
  class LabTestCategoriesController < Controller
    load_and_authorize_resource

    def index
      @categories = LabTestCategory.order('name ASC').paginate(paginate_options)
    end

    def new
      @category = LabTestCategory.new
    end


    def edit
      @category = LabTestCategory.find(params[:id])
    end

    def create
      @category = LabTestCategory.new(params[:lab_test_category])

      if @category.save
        redirect_to admin_lab_test_categories_path, notice: 'Lab Test Category has been created successfully.'
      else
        render action: "new" 
      end
    end

    def update
      @category = LabTestCategory.find(params[:id])

      if @category.update_attributes(params[:lab_test_category])
        redirect_to admin_lab_test_categories_path, notice: 'Lab Test Category has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @category = LabTestCategory.find(params[:id])
        @category.destroy
        redirect_to admin_lab_test_categories_path , :notice => 'Lab Test Category has been removed'
      rescue ActiveRecord::StatementInvalid => ex
        redirect_to admin_lab_test_categories_path , :alert => ex.message
      end
    end

  end
end