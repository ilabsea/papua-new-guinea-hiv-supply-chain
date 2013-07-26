module Admin
	class SurvSiteCommoditiesController < Controller
		def index
			@surv_site = SurvSite.find params[:surv_site_id]
			@surv_site_commodities = @surv_site.surv_site_commodities.includes(:commodity).paginate(paginate_options)
		end

	end

end