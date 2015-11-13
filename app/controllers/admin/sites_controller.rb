module Admin
  class SitesController < Controller
    load_and_authorize_resource

    def index
      @sites = Site.includes(:province).order('sites.name').paginate(paginate_options)
    end

    def show
      @site = Site.find(params[:id])
    end


    def new
      @site = Site.new(:in_every => Setting[:hour], :duration_type => Setting[:date_type])
    end

    def edit
      @site = Site.find(params[:id])
    end


    def create
      @site = Site.new(params[:site])

      if @site.save
        redirect_to admin_sites_path, notice: 'Site has been created successfully.' 
      else
        render action: "new" 
      end

    end

    def update
      @site = Site.find(params[:id])

      if @site.update_attributes(params[:site])
        redirect_to admin_sites_path, notice: 'Site has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @site = Site.find(params[:id])
        @site.destroy
        redirect_to admin_sites_url, :notice => "Site has been removed"
      rescue ActiveRecord::StatementInvalid => e
        redirect_to admin_sites_url, :alert =>  e.message
      end
    end

    def users
       site = Site.find(params[:id])
       render :json => site.users.map{|user| [user.user_name, user.id] }
    end
  end
end  
