module Admin
  class SiteMessagesController < Controller
  	def index
      @site = Site.find params[:site_id]
  		@messages = @site.site_messages.paginate(paginate_options)
  		@app_title = "#{@site.name} messages"
  	end
  end

end