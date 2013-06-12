module Admin
  class SitesController < Controller
    # GET /sites
    # GET /sites.json
    def index
      @sites = Site.paginate(paginate_options)
    end

    # GET /sites/1
    # GET /sites/1.json
    def show
      @site = Site.find(params[:id])
    end

    # GET /sites/new
    # GET /sites/new.json
    def new
      @site = Site.new
    end

    # GET /sites/1/edit
    def edit
      @site = Site.find(params[:id])
    end

    # POST /sites
    # POST /sites.json
    def create
      
      @site = Site.new(params[:site])

      if @site.save
        redirect_to admin_site_path(@site), notice: 'Site was successfully created.' 
      else
        render action: "new" 
      end

    end

    # PUT /sites/1
    # PUT /sites/1.json
    def update
      @site = Site.find(params[:id])

      if @site.update_attributes(params[:site])
        redirect_to admin_site_path @site, notice: 'Site was successfully updated.' 
      else
        render action: "edit" 
      end

    end

    # DELETE /sites/1
    # DELETE /sites/1.json
    def destroy
      @site = Site.find(params[:id])
      @site.destroy
      redirect_to admin_sites_url
    end
  end
end  
