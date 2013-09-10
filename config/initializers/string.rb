class String

  def str_tr(values)
    values = values.with_indifferent_access
    self.gsub /\{[^\}]*\}/ do |key|
      values[key[1..-2].to_sym] || '??'
    end
  end

  def is_numeric?
     (self =~/\A[-+]?[0-9]*\.?[0-9]+\Z/).nil? ? false : true
  end


  def highlight_search portion
    if(portion.present?)
      reg = Regexp.new(Regexp.escape(portion),Regexp::IGNORECASE | Regexp::MULTILINE)
      return self.gsub(reg) do |match|
        "<span class='highlight'>#{match}</span>" 
      end
    end
    self
  end

end
