class Setting < ActiveRecord::Base
  def values
    return @values if !@value.nil?
    @values = {}
    Setting.all.each do |setting|
      @values[setting.name] = { :value => setting.value , :tip => setting.tip }
    end
    @values
  end
  
end
