module Admin
  class SitesController < Controller

    def index
      @sites = Site.paginate(paginate_options)
      @app_title = "Sites"
    end

    def show
      @site = Site.find(params[:id])
      @app_title = "Site: #{@site.name}"
    end


    def new
      @site = Site.new
      @app_title = "New Site"
    end

    def edit
      @site = Site.find(params[:id])
      @app_title = "Edit site : #{@site.name}"
    end


    def create
      @site = Site.new(params[:site])

      if @site.save
        redirect_to admin_site_path(@site), notice: 'Site was successfully created.' 
      else
        render action: "new" 
      end

    end

    def update
      @site = Site.find(params[:id])

      if @site.update_attributes(params[:site])
        redirect_to admin_site_path @site, notice: 'Site was successfully updated.' 
      else
        render action: "edit" 
      end

    end
    def destroy
      begin
        @site = Site.find(params[:id])
        @site.destroy
        redirect_to admin_sites_url, :notice => "Site has been removed"
      rescue Exception => e
        redirect_to admin_sites_url, :error =>  e.message
      end
    end
  end
end  
