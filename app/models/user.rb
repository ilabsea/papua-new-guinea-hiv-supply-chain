class User < ActiveRecord::Base

  ROLES_ADMIN = "Admin"
  ROLES_REVIEWER = "Reviewer"
  ROLES_DATA_ENTRY = "Data Entry"
  ROLES_SITE = "Site"
  ROLES_AMS  = "AMS"

  ROLES = [ ROLES_ADMIN, ROLES_REVIEWER, ROLES_DATA_ENTRY, ROLES_SITE ]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,  
         #:registerable,
         :recoverable, 
         :rememberable, 
         :trackable , 
         :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :user_name, :phone_number, :display_name, :role ,
                  :email, :password, :password_confirmation, :remember_me, :site_id , :current_password
  # attr_accessible :title, :body
  
  attr_accessor :login, :current_password

  validates :user_name, :phone_number, :display_name, :presence => true
  validates :user_name, :phone_number,:uniqueness => true
  validates :email, :uniqueness => true, :allow_blank => true
  validates :role, :presence => true
  validates :site, :presence => true, :if => :site_role?

  has_many :orders
  has_many :import_survs
  belongs_to :site 
  has_many :import_survs

  def site_role?
     self.site?
  end

  def admin?
     self.role == User::ROLES_ADMIN
  end

  def reviewer?
     self.role == User::ROLES_REVIEWER
  end

  def data_entry?
     self.role == User::ROLES_DATA_ENTRY
  end

  def ams?
    self.role == User::ROLES_AMS
  end

  def site?
     self.role == User::ROLES_SITE
  end

  def reset_random_password!
      random_password =  User.regen_password
      self.password = random_password
      self.save ? random_password : false
  end

  def self.regen_password
    #Devise.friendly_token.first(8)

    child_word
  end

  def self.child_word
    file_name =  "#{Rails.root}/public/protected/words.txt"
    content = File.open(file_name){|f| f.read}.split
    self.child_word_from content 
  end

  def self.child_word_from content
    word_index = rand(content.size - 1) 
    word = content[word_index]
    "#{word}#{rand(9)}#{rand(9)}#{rand(9)}"
  end


  def email_required?
    false
  end

  def change_password? params
      self.current_password = params[:current_password]

      if !self.valid_password? self.current_password
        self.password = params[:password]
        self.password_confirmation = params[:password_confirmation]
        self.errors.add(:current_password, "is not correct") 
        return false
      else
        self.password = params[:password]
        self.password_confirmation = params[:password_confirmation]
        return self.save
      end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(user_name) = :value OR lower(email) = :value OR phone_number = :value ",
                                  :value => login.downcase ]).first
      else
        where(conditions).first
      end
  end



end
