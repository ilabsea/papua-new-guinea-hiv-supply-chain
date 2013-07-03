# app/inputs/date_time_input.rb
class DateTimePickerInput < SimpleForm::Inputs::DateTimeInput
  def input
    options = input_html_options.merge(:class => 'datepicker-input' )
    icon = '<span class="add-on"><i class="icon-calendar"> </i></span>' 
    text = "#{@builder.text_field(attribute_name, options)}"
    '<div class="input-append date datepicker" > ' + text + icon + '</div>'.html_safe
   end
end