module Admin
  class CategoriesController < Controller
    load_and_authorize_resource
    
    def index
      @categories = Category.paginate(paginate_options)
    end


    def show
      @category = Category.find(params[:id])
    end


    def new
      @category = Category.new
    end


    def edit
      @category = Category.find(params[:id])
    end


    def create
      @category = Category.new(params[:category])

      if @category.save
        redirect_to admin_categories_path, notice: 'Category has been created successfully.'
      else
        render action: "new" 
      end

    end


    def update
      @category = Category.find(params[:id])

      if @category.update_attributes(params[:category])
        redirect_to admin_categories_path, notice: 'Category has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @category = Category.find(params[:id])
        @category.destroy
        redirect_to admin_categories_url , :notice => 'Category has been removed'
      rescue Exception => ex
        redirect_to admin_categories_url , :error => ex.message
      end
      
      
    end
  end
end