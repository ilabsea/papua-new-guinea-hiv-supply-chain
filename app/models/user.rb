class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable , :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :user_name, :phone_number, :display_name, 
                  :email, :password, :password_confirmation, :remember_me, :site_id , :current_password
  # attr_accessible :title, :body
  
  attr_accessor :login, :current_password

  validates :user_name, :phone_number, :email, :uniqueness => true
  validates :site, :presence => true


  belongs_to :site  

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
