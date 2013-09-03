module Admin
  class ImportSurvsController < Controller
  	def index
  		@import_survs = ImportSurv.all.paginate(paginate_options)
  	end

  	def new
  		type = params[:type] ||  ImportSurv::TYPES_SURV1
  		@import_surv = ImportSurv.new(:surv_type => type)
  		@sites = Site.all


  		@commodities = Commodity.from_type(@import_surv.arv_type)
      @commodity_categories = CommodityCategory.from_type @import_surv.arv_type

  		@app_title = 'New ' + @import_surv.surv_type

  		@sites.each do |site|
  		  surv_site = @import_surv.surv_sites.build(:site => site, :surv_type => @import_surv.surv_type)
  		  @commodities.each do |commodity|
  		  	surv_site.surv_site_commodities.build(:commodity => commodity, :quantity => '' )
  		  end
  		end
  	end

  	def create
  		@import_surv = ImportSurv.new params[:import_surv]
  		@import_surv.user = current_user

  		if(@import_surv.save)
  		  redirect_to admin_import_survs_path(:type =>@import_surv.surv_type), :notice => 'Surv site has been created'
  		else 
  		  @sites = Site.all
  		  @commodities = Commodity.from_type(@import_surv.arv_type)	
  		  render :new
  		end	
  	end

  	# DELETE /provinces/1
    # DELETE /provinces/1.json
    def destroy
      begin
        @province = ImportSurv.find(params[:id])
        @province.destroy
        redirect_to admin_import_survs_path(:type => params[:type]), :notice => "Surv site has been removed" 
      rescue Exception => e
        redirect_to admin_import_survs_path(:type => params[:type] ), :error =>  e.message 
      end
    end

  	def view
  		@import_surv = ImportSurv.includes(:surv_sites).find(params[:id])
  		@sites = Site.all
  		@commodities = Commodity.from_type(@import_surv.arv_type)
  	end

  	def import_form
		@import_surv = current_user.import_survs.build
	end

	def import
		@import_surv = current_user.import_survs.build params[:import_surv]
		if @import_surv.surv_type != nil && !@import_surv.form.blank?
			@import_surv.validate_surv_form
		end
		if @import_surv.is_form_error?
			flash.now[:alert] = "Import failed ! The following fields are missing."
			render :field_error
		else
			if @import_surv.save				
			   @import_surv.import
			   redirect_to admin_import_survs_path, notice: 'SURV Form has been successfully imported.'
			else
				_fill_attribute
				if @import_surv.save				
					ImportSurv.import(@import_surv)
					redirect_to  new_admin_import_surv_path(), :notice => 'SURV Form has been successfully imported.'
				else
					render :new
				end
			end
		end
	end


	def _fill_attribute
		@import_surv.import_user = current_user
	end
	def index
		@type = params[:type] || ImportSurv::TYPES_SURV1
		@import_survs = current_user.import_survs.of_type(@type).paginate(paginate_options)
	end

	def download
		@import_surv = ImportSurv.find params[:id]
	    send_file(@import_surv.form.current_path , 
	                      :filename      =>  "surv#{@import_surv.surv_type}.xls",
	                      :type          =>  'application/xls',
	                      :disposition   =>  'attachment',
	                      :streaming     =>  true,
	                      :buffer_size   =>  '4096')
	end

  end
end