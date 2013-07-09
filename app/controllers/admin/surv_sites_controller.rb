module Admin
	class SurvSitesController < Controller
		def index
			@import_surv = ImportSurv.find params[:import_surv_id]
			@surv_sites =  @import_surv.surv_sites.includes(:site).paginate(paginate_options)
		end

	end


end