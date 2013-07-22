require 'spreadsheet'

class ImportSurv < ActiveRecord::Base

  belongs_to :user
  has_many :surv_sites, :dependent => :destroy

  attr_accessor :invalid_fields
  # validates_format_of :form, :with => %r{\.(xls)$}i, :message => "Only .xls format is excepted"
  # validates :surv_type, :presence  =>  true
  # validates :form, :presence => true  

  attr_accessible :surv_type, :surv_sites_attributes, :year, :month

  default_scope order("id DESC")

  TYPES_SURV1  = 'SURV1'
  TYPES_SURV2  = 'SURV2'

  TYPES = [ TYPES_SURV1,  TYPES_SURV2 ]

  MONTHS = ['January' ,'February','March' ,'April', 'May', 'June', 'July', 'August', 'September', 'Octomber', 'November', 'December' ]
  
  validates :month, inclusion: { :in => MONTHS, :message => "%{value} is not a valid month" }
  validates :year, :numericality => { :only_integer => true}
  validate :uniqueness_of_year_month

  mount_uploader :form, RequisitionReportUploader
  accepts_nested_attributes_for :surv_sites


  def uniqueness_of_year_month
    import = ImportSurv.where([ 'month = :month AND year = :year and surv_type = :type', 
                                :month => self.month, :year => self.year, :type => self.surv_type ]).first
    if(!import.nil? && import.id != self.id)
      errors.add(:year, "#{self.month}, #{self.year} has already had surv site")
      errors.add(:month, "#{self.month}, #{self.year} has already had surv site")
    end

  end

  def self.of_type type
      ImportSurv.where('surv_type = ? ', type)
  end

  def validate_surv_form 
    file_name = self.form.current_path
    @book = Spreadsheet.open(file_name)
    if self.surv_type == TYPES_SURV1
      invalid_fields = validate_surv1 
    elsif self.surv_type == TYPES_SURV2
      invalid_fields = validate_surv2
    end
    invalid_fields
  end

  def arv_type
    if self.surv_type == ImportSurv::TYPES_SURV1
      return CommodityCategory::TYPES_DRUG
    else
      return CommodityCategory::TYPES_KIT
    end  
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
          arr_none_exist_sites << row[0] unless _site(row[0])
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
          arr_none_exist_sites << row[0] unless _site(row[0])
        end
      end
    end
    return arr_none_exist_sites.uniq
  end

  def find_none_exist_commodities commodity
    arr_none_exist_commodities = []
    commodity.each do |el|
      arr_none_exist_commodities << el unless _commodity{|commodity| commodity.name == el }
    end
    return arr_none_exist_commodities
  end

  def find_none_exist_commodities_in_surv2 commodity
    arr_none_exist_commodities = []
    commodity.each do |el|
      arr_none_exist_commodities << el unless _commodity{|commodity| commodity.abbreviation == el}
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

  def import
  	file_name = self.form.current_path
  	@book = Spreadsheet.open(file_name)
    self.surv_type == TYPES_SURV1 ? read_file_surv1 : read_file_surv2
	end

  def read_file_surv2
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
        site_name = row[0]
        site = _site(site_name)
        if site
          surv_site = SurvSite.create!(:import_surv_id => self.id, 
                                       :site_id => site.id, 
                                       :month => row[2], 
                                       :year => row[3],
                                       :surv_type => TYPES_SURV2 
                                       )
          surv_site_commodities = []
          for j in 0..arr_commodity.count-1 
            commodity_abbreviation = arr_commodity[j]
            commodity = _commodity{|commodity| commodity.abbreviation == commodity_abbreviation}
            if (commodity)
              quantity = row[commodity_quantity_index + j]
              surv_site_commodities << SurvSiteCommodity.new( :surv_site_id => surv_site.id, 
                                                              :commodity_id => commodity.id, 
                                                              :quantity => quantity)
            end
          end
          if surv_site_commodities.count > 0
            SurvSiteCommodity.import surv_site_commodities 
            SurvSite.reset_counters surv_site.id, :surv_site_commodities
          end

        end
      end
    end
  end

  def read_file_surv1
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
        site_name = row[0]
        site =  _site(site_name)
        if site
          surv_site_commodities = []
          surv_site = SurvSite.create!(:import_surv_id => self.id, 
                                       :site_id => site.id, 
                                       :month => _full_month(row[2]), 
                                       :year => row[3],
                                       :surv_type => TYPES_SURV1 )

          for j in 0..arr_commodity.count-1 
            commodity_name = arr_commodity[j]
            commodity =  _commodity{|commodity| commodity.name == commodity_name  }  
            if (commodity)
              quantity = row[commodity_quantity_index + j]
              surv_site_commodities << SurvSiteCommodity.new(:surv_site_id => surv_site.id, 
                                                             :commodity_id => commodity.id, 
                                                             :quantity => quantity)
            end
          end

          if surv_site_commodities.count > 0
            SurvSiteCommodity.import surv_site_commodities 
            SurvSite.reset_counters surv_site.id, :surv_site_commodities
          end

        end
      end
    end
  end

  private

  def _full_month month
    months = ['January' , 'February' ,'March' , 'April', 'May', 'June', 'July', 'August', 'September', 'Octomber', 'November', 'December' ]
    months.each do |m|
      return m if m.start_with? month
    end
    raise month + " : is not in the list of supported months(#{months.join(', ')})"
  end

  def _sites
    @sites ||= Site.all
  end

  def _site(name)
    _sites.each do |site|
      return site if site.name == name
    end
    return nil
  end

  def _commodity(&block)
    _commodities.each do |commodity|
      return commodity if block.call(commodity)
    end
    return nil
  end

  def _commodities
    @commodities ||= Commodity.all
  end

end
