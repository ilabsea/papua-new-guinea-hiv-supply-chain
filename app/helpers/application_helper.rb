module ApplicationHelper
  def app_name
    "PNG HIV/Aids"
  end
  
  def page_header title, options={},  &block
     left_size  = options[:left] || 8
     right_size = options[:right] || (12 - left_size) 
    
     content_tag :div,:class => "row-fluid list-header" do
        if block_given? 
            content_title = content_tag :div, :class => "span#{left_size} left" do
              content_tag(:h3, title)
            end

            output = with_output_buffer(&block)
            content_link = content_tag(:div, output, {:class => "span#{right_size} right top-15"})
            content_title + content_link
        else
            content_tag :div , :class => "row-fluid" do 
               content_tag(:h3, title)
            end
        end 
     end
  end
  
  
  
end
