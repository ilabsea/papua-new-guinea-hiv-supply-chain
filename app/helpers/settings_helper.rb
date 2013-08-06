module SettingsHelper
  def parameters_links(el)
  	# parameters = "parameter link"
    # parameters = Setting::MESSAGE_KEYS.map{|val| }
    # debug el[:params]
    parameters = el[:params].map do |param| 
    	 link_to "{#{param}}", 'javascript:void(0)', :class => 'parameter_link', :data => {:id => el[:name], :'skip-loading' => true } 
   	end.join(', ')
   	%Q(<span style="font-size:90%">Parameters: #{parameters}</span>).html_safe
  end
end