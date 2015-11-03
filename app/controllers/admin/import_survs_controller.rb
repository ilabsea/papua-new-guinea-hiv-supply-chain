module Admin
  class ImportSurvsController < Controller
    load_and_authorize_resource

    def index
      @type = params[:type] || ImportSurv::TYPES_SURV1
      @import_survs = ImportSurv.of_type(@type).order('year,month').paginate(paginate_options)
    end

    def edit
      load_import_surv
      load_and_prepare_data
    end

    def update
      load_import_surv

      if(@import_surv.update_attributes(params[:import_surv]))
        redirect_to admin_import_survs_path(:type => @import_surv.surv_type), :notice => 'Surv form has been updated successfully'
      else
        load_and_prepare_data
        render :edit
      end
    end

    def new
      type = params[:type] ||  ImportSurv::TYPES_SURV1
      @import_surv = ImportSurv.new(:surv_type => type)

      load_and_prepare_data
    end

    def create
      @import_surv = ImportSurv.new params[:import_surv]
      @import_surv.user = current_user

      if(@import_surv.save)
        redirect_to admin_import_survs_path(:type =>@import_surv.surv_type), :notice => 'Surv site has been created'
      else 
        load_and_prepare_data
        render :new
      end
    end

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
      load_import_surv
      @sites = Site.order('name').all
      load_commodities_from_surv(@import_surv)
    end

    def load_commodities_from_surv
      @commodities = Commodity.includes(:commodity_category, :regimen, :lab_test)
                              .from_type(@import_surv.arv_type)
                              .order('commodities.position, commodities.name')
    end

    def load_import_surv
      @import_surv = ImportSurv.includes(surv_sites: [:site, surv_site_commodities: [ commodity: [:lab_test, :regimen, :commodity_category]]])
                                 .order('commodities.position, commodities.name')
                                 .find(params[:id])
    end

    def load_sites
      @sites = Site.order('name').all
      @sites
    end

    def load_and_prepare_data
      load_sites
      load_commodities_from_surv

      existing_sites = @import_surv.surv_sites.map(&:site_id)


      @sites.each do |site|
        next if existing_sites.include?(site.id)
        surv_site = @import_surv.surv_sites.build(:site => site, :surv_type => @import_surv.surv_type)
        @commodities.each do |commodity|
          surv_site.surv_site_commodities.build(:commodity => commodity, :quantity => '' )
        end
      end
    end

  end

end