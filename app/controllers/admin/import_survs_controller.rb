module Admin
  class ImportSurvsController < Controller
    load_and_authorize_resource

    def index
      @type = params[:type] || ImportSurv::TYPES_SURV1
      @import_survs = ImportSurv.of_type(@type).order('year,month').paginate(paginate_options)
    end

    def edit
      @import_surv  = ImportSurv.find params[:id]
      @sites = Site.order('name').all
      load_commodity_from_surv(@import_surv)

      existing_sites = @import_surv.surv_sites.map(&:site_id)

      @sites.each do |site|
        next if existing_sites.include?(site.id)
        surv_site = @import_surv.surv_sites.build(:site => site, :surv_type => @import_surv.surv_type)
        @commodities.each do |commodity|
          surv_site.surv_site_commodities.build(:commodity => commodity, :quantity => '' )
        end
      end

    end

    def update
      @import_surv = ImportSurv.find params[:id]

      if(@import_surv.update_attributes(params[:import_surv]))
        redirect_to admin_import_survs_path(:type => @import_surv.surv_type), :notice => 'Surv form has been updated successfully'
      else
        @sites = Site.order('name').all
        load_commodity_from_surv(@import_surv)
        existing_sites = @import_surv.surv_sites.map(&:site_id)

        @sites.each do |site|
          next if existing_sites.include?(site.id)
          surv_site = @import_surv.surv_sites.build(:site => site, :surv_type => @import_surv.surv_type)
          @commodities.each do |commodity|
            surv_site.surv_site_commodities.build(:commodity => commodity, :quantity => '' )
          end
        end

        render :edit
      end
    end

    def new
      type = params[:type] ||  ImportSurv::TYPES_SURV1
      @import_surv = ImportSurv.new(:surv_type => type)
      @sites = Site.order('name').all
      load_commodity_from_surv(@import_surv)

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
        @sites = Site.order('name').all
        load_commodity_from_surv(@import_surv)
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
      @import_surv = ImportSurv.includes(:surv_sites => [:surv_site_commodities, :site] ).find(params[:id])
      @sites = Site.order('name').all
      load_commodity_from_surv(@import_surv)
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

    def download
      @import_surv = ImportSurv.find params[:id]
        send_file(@import_surv.form.current_path , 
                          :filename      =>  "surv#{@import_surv.surv_type}.xls",
                          :type          =>  'application/xls',
                          :disposition   =>  'attachment',
                          :streaming     =>  true,
                          :buffer_size   =>  '4096')
    end

    def filter_empty_site
      import_surv[surv_sites_attributes][0][surv_site_commodities_attributes][0][quantity]

      import_surv_params = params[:import_surv]
      filter_params = []
    end

    def load_commodity_from_surv(import_surv)
      @commodities = Commodity.includes(:commodity_category, :regimen, :lab_test)
                              .from_type(import_surv.arv_type)
                              .order('commodities.name')
    end

  end
end