module Admin
  class SurvSitesController < Controller
    def index
      @import_surv = ImportSurv.find params[:import_surv_id]
      @surv_sites =  @import_surv.surv_sites.includes(:site).paginate(paginate_options)
    end

    def new
        type = params[:type] || CommodityCategory::TYPES_DRUG 
      @surv_site = SurvSite.new :surv_type => type
    end


    def surv_site_commodities surv_site
      Commodity.order("name asc").from_type(surv_site.surv_type).each do |commodity|
        surv_site.surv_site_commodities.build(:site => surv_site, :commodity => commodity )
      end

    end

  end


end