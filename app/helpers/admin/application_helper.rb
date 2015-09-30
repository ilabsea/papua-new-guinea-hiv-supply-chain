module Admin::ApplicationHelper
  def app_name
    ENV['APP_NAME']
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

  def error_label error
    if error == 0 || error == 'No'
      type = 'label-success'
    else
      type = 'label-important'
    end
    label_value error, type
  end

  def shipment_status status
    type = ''
    if status == Shipment::STATUS_LOST
      type = 'label-important'
    elsif status == Shipment::STATUS_IN_PROGRESS
      type = ''
    
    elsif status == Shipment::STATUS_PARTIALLY_RECEIVED
      type = 'label-warning'

    elsif status == Shipment::STATUS_RECEIVED
      type = 'label-success'
    end
    label_value status, type
  end

  def label_value value, type="label-info"
    content_tag :span, value, :class => "label #{type}"
  end

  def badge_value value, type='badge-warning'
    content_tag :span, value, :class => "badge #{type}"
  end
  
  def paginate_records records
    content_tag :div , :class => "paginator right" do
      will_paginate records, renderer: BootstrapPagination::Rails
    end
  end

  def paginate_entries records
    if require_paginate_for? records
      content_tag :div, :class => 'paginator paginator-entry badge right' do
        #pluralize(records.length, 'record')  + ' of ' + records.total_entries.to_s + ' in total'
        "#{records.length} / #{records.total_entries}"
      end 
    end
  end

  def render_paginate_for records
    content_tag(:div, :class => 'row-fluid') do
     [ 
      content_tag(:div, :class => 'span4') do
        paginate_entries records
      end,
      content_tag(:div, :class => 'span8') do
        paginate_records records
      end
      ].join("").html_safe 
    end
  end
  
  def breadcrumb_str options
		items = []
		char_sep = "&raquo;".html_safe
		if( !options.nil?  && options.size != 0)
			items <<  content_tag(:li , :class => "active") do
				link_to_home("Home", admin_root_path) + content_tag(:span, char_sep, :class => "divider")
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
      icon = content_tag "i", " ", :class => "icon-user  icon-home"
			items << content_tag(:li, icon + "Home", :class => "active")	
		end
		items.join("").html_safe
	end

  def field_sorted_in_shipments_path_for field
    options         = params.except(:controller, :action, :order, :field)
    options[:field] = field 
    
    if params[:order].blank?
      options[:order] = 'desc'
    elsif params[:order] == 'asc'
      options[:order] = 'desc'
    elsif params[:order] == 'desc'  
      options[:order] = 'asc'
    end
    admin_shipments_path(options)
  end

  def link_button type, text, url, options={}
    # options[:class] = options[:class] ? "#{options[:class]}" : ""
    icon = content_tag "i", " ", :class => "#{type} "
    link_to (icon + " #{text}".html_safe), url, options
  end

  def link_button_save text, url, options={}
    link_to text, url, options
  end

  def link_button_edit text, url, options={}
    # options[:class] = options[:class].nil? ? "btn btn-mini btn-info" : "btn btn-mini btn-info #{options[:class] }"
    link_to  url, options do
      icon('edit') + " #{text}"
    end
  end

  def link_button_new text, url, options={}
    options[:class] = options[:class].nil? ? "btn" : "btn #{options[:class] }"
    link_button 'icon-plus', text, url, options
  end

  def link_button_delete text, url, options={}
    link_to  url, options do
      icon('trash') + " #{text}"
    end
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
    link_button_download text, url, options
  end

  def link_button_reset text, url, options={}
    link_button 'icon-repeat', text, url, options
  end

  def link_button_cancel text, url, options={}
    options[:class] = options[:class] ? "btn #{options[:class] }" : "btn"
    link_to text, url, options
  end

  def link_button_signout text, url, options={}
    link_button 'icon-arrow-right', text, url, options
  end

  def link_button_tick text, url, options={}
    link_button 'icon-ok', text, url, options
  end

  def link_button_minus text, url, options={}
    link_button 'icon-minus-sign' , text, url, options
  end

  def link_button_download text, url, options={}
    options = options.merge(:'data-skip-loading' => true)
    link_button 'icon-download-alt', text, url, options
  end

  def link_to_home text, url, options={}
    icon = content_tag "i", " ", :class => "icon-home"
    link_to (icon + text.html_safe), url, options
  end

  def button_save text, klass=''
    content_tag :button, :class => "btn btn-primary #{klass}", :'data-system-loading' => true do
      content_tag("i", '', :class => 'icon-ok') + " " + text
    end
  end

  def breadcrumb options=nil
    content_tag(:ul, breadcrumb_str(options), :class => "breadcrumb")
  end

  def status st
    text = ""
    if st == OrderLine::STATUS_APPROVED
      text = '<i class="icon-ok" > </i>'
    
    elsif st == OrderLine::STATUS_REJECTED
       text = '<i class="icon-minus-sign" ></i>'
    end
    text.html_safe
  end

  def time_ago_tag date_time
    format =  date_time.class == Date ? ENV['DATE_FORMAT'] : ENV['DATE_TIME_FORMAT']
    timeago_tag date_time, :nojs => true, :limit => 20.days.ago, format: format
  end

  def show_date(date)
    date ? date.strftime(ENV['DATE_FORMAT']) : ''
  end

  def show_date_time date_time
    date_time ? date_time.strftime(ENV['DATE_TIME_FORMAT']) : ''
  end

  def nav_status(controllers=[])
    controllers.include?(controller_name.to_sym) ? ' active ' : ''
  end

end
