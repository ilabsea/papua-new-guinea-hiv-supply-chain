module Admin::ApplicationHelper
  def app_name
    "HIV Supply Chain"
  end
  
  def app_title
     @app_title.nil? ?  app_name : (@app_title + " &raquo; ").html_safe + app_name
  end
  
  def page_header title, options={},  &block
     left_size  = options[:left] || 8
     right_size = options[:right] || (12 - left_size) 
    
     content_tag :div,:class => "row-fluid list-header" do
        if block_given? 
            content_title = content_tag :div, :class => "span#{left_size} left" do
              content_tag(:h3, title, :class => "header-title")
            end

            output = with_output_buffer(&block)
            content_link = content_tag(:div, output, {:class => "span#{right_size} right top-15"})
            content_title + content_link
        else
            content_tag :div , :class => "row-fluid" do 
               content_tag(:h3, title, :class => "header-title")
            end
        end 
     end
  end
  
  def paginate_records records
    content_tag :div , :class => "paginator right" do
      will_paginate records, renderer: BootstrapPagination::Rails
    end
  end
  
  def breadcrumb_str options
		items = []
		char_sep = "&raquo;".html_safe
		if( !options.nil?  && options.size != 0)
			items <<  content_tag(:li , :class => "active") do
				link_to("Home", admin_root_path) + content_tag(:span, char_sep, :class => "divider")
			end
			options.each do |option|
				option.each do |key, value|
				  if value
					items << content_tag(:li) do
						link_to(key, value) + content_tag(:span, char_sep, :class => "divider")
					end 
				  else
					  items << content_tag(:li, key, :class =>"active") 
				  end
				end
			end	
		else
			items << content_tag(:li, "Home", :class => "active")	
		end
		items.join("").html_safe
	end

  def link_button type, text, url, options
    options[:class] = options[:class] ? " btn #{options[:class]}" : "btn" 
    icon = content_tag "i", " ", :class => "icon-user  #{type} "
    link_to (icon + text.html_safe), url, options
  end

  def link_button_edit text, url, options={}
    link_button 'icon-edit', text, url, options
  end

  def link_button_new text, url, options={}
    link_button 'icon-plus', text, url, options
  end

  def link_button_delete text, url, options={}
    link_button 'icon-ban-circle', text, url, options
  end

  def link_button_search text, url, options={}
    link_button ' icon-search', text, url, options
  end

  def link_button_show text, url, options={}
    link_button 'icon-th-large', text, url, options
  end

  def link_button_review text, url, options={}
    link_button 'icon-pencil', text, url, options
  end

  def link_button_export text, url, options={}
    link_button 'icon-download-alt', text, url, options
  end

	def breadcrumb options=nil
		content_tag(:ul, breadcrumb_str(options), :class => "breadcrumb")
	end

  def status st
    text = ""
    if st == OrderLine::STATUS_APPROVED
      text = '<i class="icon-ok" > </i>'
    
    elsif st == OrderLine::STATUS_REJECTED
       text = '<i class="icon-minus-sign" > </i>'
    end
    text.html_safe
  end 
end
