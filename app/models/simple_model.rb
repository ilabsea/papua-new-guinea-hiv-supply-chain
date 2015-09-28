class SimpleModel < ActiveRecord::Base
  self.abstract_class = true

  cattr_accessor :date_format_attributes, :date_time_format_attributes
  before_save :convert_date_format
  before_save :convert_date_time_format

  def self.has_date_time_format *attr_names
    self.date_time_format_attributes ||= []

    attr_names.each do |attr_name|
      self.date_time_format_attributes << attr_name
    end
  end

  def self.has_date_format *attr_names
    self.date_format_attributes ||= []

    attr_names.each do |attr_name|
      self.date_format_attributes << attr_name
    end
  end

  def convert_date_time_format
    self.class.date_time_format_attributes ||= []
    self.class.date_time_format_attributes.each do |attr|
      value = self.send(attr)
      next unless value.present?

      if value.class == String
        value = DateTime.strptime(value, ENV['DATE_TIME_FORMAT'])
        self.send("#{attr}=", value)
      end

    end
  end

  def convert_date_format
    self.date_format_attributes ||= []
    self.class.date_format_attributes.each do |attr|
      value = self.send(attr)
      next unless value.present?

      if value.class == String
        value = Date.strptime(value, ENV['DATE_FORMAT'])
        self.send("#{attr}=", value)
      end

    end
  end

end