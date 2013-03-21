class User < ActiveRecord::Base

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable         

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :phone, :password, :password_confirmation, :remember_me, :locations, :theme, :locations_attributes

  enum_attr :theme, %w(default amelia slate united)

  validates_presence_of :name
  #validates_uniqueness_of :name

  has_many :locations, :as => :locatable

  accepts_nested_attributes_for :locations, allow_destroy: true

  before_validation strip_attributes :except => [:phone, :password, :password_confirmation]

  validates :name, :length => { :maximum => 255 }
  validates :email, :length => { :maximum => 255 }
  validates :phone, :length => { :maximum => 16 }
  validates :password, :length => { :maximum => 255 }

  after_create :assign_default_role
  after_save :assign_default_role

  def phone=(num)
    num.gsub!(/\D/, '') if num.is_a?(String)
    super(num)
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ? or email LIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

  private

    def assign_default_role
      unless has_role? :admin
        add_role(:user)
      end
    end

end
