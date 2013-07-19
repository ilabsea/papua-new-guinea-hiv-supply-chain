module Admin
  class ImportSurvsController < Controller
  	def new
  		type = params[:type] ||  ImportSurv::TYPES_SURV1
  		@import_surv = ImportSurv.new(:surv_type => type)
  		@sites = Site.all
  		@commodities = Commodity.from_type(@import_surv.arv_type)

  		@sites.each do |site|
  		  surv_site = @import_surv.surv_sites.build(:site => site)
  		  @commodities.each do |commodity|
  		  	surv_site.surv_site_commodities.build(:commodity => commodity, :quantity => '' )
  		  end
  		end
  	end

  	def create
  		@import_surv = ImportSurv.new params[:import_surv]
  		@import_surv.user = current_user

  		if(@import_surv.save)
  		  redirect_to admin_import_survs_path, :notice => 'Surv site has been created'
  		else 
  		  @sites = Site.all
  		  @commodities = Commodity.from_type(@import_surv.arv_type)	
  		  render :new
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
				render :new
			end
		end
	end

	def index
		@import_survs = current_user.import_survs.paginate(paginate_options)
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