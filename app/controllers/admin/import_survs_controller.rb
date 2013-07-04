module Admin
  class ImportSurvsController < Controller
  	def new
			@import_surv = ImportSurv.new
		end

		def create
			@import_surv = ImportSurv.new params[:import_surv]
			if @import_surv.surv_type != nil && !@import_surv.form.blank?
				@import_surv.validate_surv_form
			end
			if @import_surv.is_form_error?
				flash.now[:alert] = "Import failed ! The following fields are missing."
				render :field_error
			else
				_fill_attribute
				if @import_surv.save				
					ImportSurv.import(@import_surv)
					redirect_to admin_import_survs_path+"/new", notice: 'SURV Form has been successfully imported.'
				else
					render :new
				end
			end
		end

		def _fill_attribute
			@import_surv.import_user = current_user.id
		end
	end
end