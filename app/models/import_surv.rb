require 'spreadsheet'

class ImportSurv < ActiveRecord::Base
  attr_accessible :import_user, :form, :surv_type
  attr_accessor :invalid_fields

  has_one :surv_site
  belongs_to :import_user, :class_name => 'User'

  validates_format_of :form, :with => %r{\.(xls)$}i, :message => "Only .xls format is excepted"
  validates :import_user, :form, :surv_type, :presence   =>  true

  TYPES_SURV_1 = 1
  TYPES_SURV_2  = 2

  TYPES = [ ["SURV 1", TYPES_SURV_1], ["SURV 2", TYPES_SURV_2] ]

  mount_uploader :form, RequisitionReportUploader

  def surv_type_display
     ImportSurv::TYPES.each do |type|
       return type[0] if(type[1] == self.surv_type)
     end
  end

  def validate_surv_form 
    file_name = self.form.current_path
    @book = Spreadsheet.open(file_name)
    if (self.surv_type == 1)
      invalid_fields = validate_surv1
    else
      invalid_fields = validate_surv2
    end
    invalid_fields
  end

  def validate_field
    errors.add(:surv_type, "can't be blank") if self.surv_type.nil?
  end

  def validate_surv1
    sheet_arv_request = @book.worksheet 0
    total_rows = sheet_arv_request.count
    header_row = sheet_arv_request.row 0
    min_commodity_column = 4
    max_commodity_column = header_row.count
    total_row_data = max_commodity_column - min_commodity_column
    commodity_quantity_index = 4
    @invalid_fields = {}
    arr_commodity = []
    total_row_data.times.each do |k|
      index = min_commodity_column + k
      arr_commodity << header_row[index]
    end
    @invalid_fields[:site] = find_non_exist_sites sheet_arv_request    
    @invalid_fields[:commodity] = find_none_exist_commodities arr_commodity
  end

  def is_form_error?
    return false if @invalid_fields.nil?
    @invalid_fields[:site].size > 0 || @invalid_fields[:commodity].size > 0
  end

  def find_non_exist_sites sheet_arv_request
    total_rows = sheet_arv_request.count
    arr_none_exist_sites = []
    total_rows.times.each do |i|
      if (i>0)
        row = sheet_arv_request.row i
        if !row[0].nil?
          arr_none_exist_sites << row[0] unless Site.find_by_name(row[0])
        end
      end
    end
    return arr_none_exist_sites
  end

  def find_non_exist_sites_in_surv2 sheet_arv_request
    total_rows = sheet_arv_request.count
    arr_none_exist_sites = []
    total_rows.times.each do |i|
      if (i>2)
        row = sheet_arv_request.row i
        if !row[0].nil?
          arr_none_exist_sites << row[0] unless Site.find_by_name(row[0])
        end
      end
    end
    return arr_none_exist_sites.uniq
  end

  def find_none_exist_commodities commodity
    arr_none_exist_commodities = []
    commodity.each do |el|
      arr_none_exist_commodities << el unless Commodity.find_by_name(el)
    end
    return arr_none_exist_commodities
  end

  def find_none_exist_commodities_in_surv2 commodity
    arr_none_exist_commodities = []
    commodity.each do |el|
      arr_none_exist_commodities << el unless Commodity.find_by_abbreviation(el)
    end
    return arr_none_exist_commodities
  end

  def validate_surv2
    sheet_arv_request = @book.worksheet 0
    total_rows = sheet_arv_request.count
    header_row = sheet_arv_request.row 1
    min_commodity_column = 27
    max_commodity_column = header_row.count
    total_row_data = max_commodity_column - min_commodity_column
    commodity_quantity_index = 27
    @invalid_fields = {}
    arr_commodity = []
    total_row_data.times.each do |k|
      index = min_commodity_column + k
      arr_commodity << header_row[index] unless header_row[index].nil?
    end
    @invalid_fields[:site] = find_non_exist_sites_in_surv2 sheet_arv_request    
    @invalid_fields[:commodity] = find_none_exist_commodities_in_surv2 arr_commodity
  end

  def self.import import_surv
    @import_surv = import_surv
  	file_name = import_surv.form.current_path
  	@book = Spreadsheet.open(file_name)
    if (import_surv.surv_type == 1)
      read_file_surv1
    else
      read_file_surv2
    end
	end

  def self.read_file_surv2
    sheet_arv_request = @book.worksheet 0
    total_rows = sheet_arv_request.count
    header_row = sheet_arv_request.row 1
    min_commodity_column = 27
    max_commodity_column = header_row.count
    commodity_quantity_index = 27
    arr_commodity = []

    for k in min_commodity_column..max_commodity_column
      arr_commodity << header_row[k]
    end
    

    total_rows.times.each do |i|
      if (i > 2)
        row = sheet_arv_request.row i
        site = Site.find_by_name(row[0])
        if site
          surv_site = SurvSite.create!(:import_surv_id => @import_surv.id, :site_id => site.id, :month => row[2], :year => row[3])
          for j in 0..arr_commodity.count-1 
            commodity = Commodity.find_by_abbreviation(arr_commodity[j])
            if (commodity)
              quantity = row[commodity_quantity_index + j]
              SurvSiteCommodity.create!(:surv_site_id => surv_site.id, :commodity_id => commodity.id, :quantity => quantity)
            end
          end
        end
      end
    end
  end

  def self.read_file_surv1
    sheet_arv_request = @book.worksheet 0
    total_rows = sheet_arv_request.count
    header_row = sheet_arv_request.row 0
    min_commodity_column = 4
    max_commodity_column = header_row.count
    commodity_quantity_index = 4
    arr_commodity = []

    for k in min_commodity_column..max_commodity_column
      arr_commodity << header_row[k]
    end

    total_rows.times.each do |i|
      if (i > 0)
        row = sheet_arv_request.row i
        site = Site.find_by_name(row[0])
        if site
          surv_site = SurvSite.create!(:import_surv_id => @import_surv.id, :site_id => site.id, :month => row[2], :year => row[3])
          for j in 0..arr_commodity.count-1 
            commodity = Commodity.find_by_name(arr_commodity[j])
            if (commodity)
              quantity = row[commodity_quantity_index + j]
              SurvSiteCommodity.create!(:surv_site_id => surv_site.id, :commodity_id => commodity.id, :quantity => quantity)
            end
          end
        end
      end
    end
  end

end
