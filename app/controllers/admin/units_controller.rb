module Admin
  class UnitsController < Controller
    load_and_authorize_resource
    
  	def index
  		@units = Unit.order("name").paginate(paginate_options)
  	end

  	def new
  	  @unit = Unit.new
  	end

  	def create
  	   @unit = Unit.new params[:unit]
  	   if(@unit.save)
  	   	  redirect_to admin_units_path, :notice => "Unit has been saved successfully"
  	   else
  	   	  render :new
  	   end
  	end

    def edit
      @unit = Unit.find(params[:id])
    end

    def update
      @unit = Unit.find(params[:id])
      if @unit.update_attributes(params[:unit])
         redirect_to admin_unit_path(@unit), :notice => "Unit has been updated successfully"
      else
         render :edit
      end     
    end

    def destroy
      begin
        @unit = Unit.find(params[:id])
        @unit.destroy
        redirect_to admin_units_path, :notice => "Unit has been removed"
      rescue Exception => e
        redirect_to admin_units_path, :error => e.message
      end
    end

  end


end