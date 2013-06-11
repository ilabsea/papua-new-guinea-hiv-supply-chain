module Admin
  class CategoriesController < ApplicationController
    
    def index
      @categories = Category.all
      @app_title = "Categories"
    end


    def show
      @category = Category.find(params[:id])
      @app_title = "Category :" + @category.name
    end


    def new
      @category = Category.new
    end


    def edit
      @category = Category.find(params[:id])
      @app_title = "Edit: " + @category.name
    end


    def create
      @category = Category.new(params[:category])

      if @category.save
        redirect_to admin_category_path(@category), notice: 'Category was successfully created.'
      else
        render action: "new" 
      end

    end


    def update
      @category = Category.find(params[:id])

      if @category.update_attributes(params[:category])
        redirect_to admin_category_path(@category), notice: 'Category was successfully updated.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      @category = Category.find(params[:id])
      @category.destroy
      redirect_to admin_categories_url 
    end
  end
end