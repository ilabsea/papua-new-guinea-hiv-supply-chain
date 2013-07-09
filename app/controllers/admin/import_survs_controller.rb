module Admin
  class ImportSurvsController < Controller
  	def new
			@import_surv = current_user.import_survs.build
		end

		def create
			@import_surv = current_user.import_survs.build params[:import_surv]
			if @import_surv.surv_type != nil && !@import_surv.form.blank?
				@import_surv.validate_surv_form
			end
			if @import_surv.is_form_error?
				flash.now[:alert] = "Import failed ! The following fields are missing."
				render :field_error
			else
				if @import_surv.save				
					ImportSurv.import(@import_surv)
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