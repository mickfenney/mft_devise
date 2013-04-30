# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  phone                  :string(255)
#  theme                  :string(255)      default("default")
#

class User < ActiveRecord::Base

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :async      

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :name, :email, :phone, :password, :password_confirmation, :locations, :theme, :locations_attributes, :as => :admin
  attr_accessible :name, :email, :phone, :password, :password_confirmation, :remember_me, :locations, :theme, :locations_attributes

  enum_attr :theme, ['default', 'amelia', 'slate', 'united'].sort

  validates_presence_of :name, :theme
  #validates_uniqueness_of :name

  has_many :locations, :as => :locatable

  accepts_nested_attributes_for :locations, allow_destroy: true

  before_validation strip_attributes :except => [:phone, :password, :password_confirmation]

  validates :name, :length => { :maximum => 255 }
  validates :email, :length => { :maximum => 255 }
  validates :phone, :length => { :maximum => 15 }

  after_create :assign_default_role
  after_save :assign_default_role

  def phone=(num)
    num.gsub!(/\D/, '') if num.is_a?(String)
    super(num)
  end

  private

    def assign_default_role
      unless has_role? :admin
        add_role(:user)
      end
    end

    def self.search(search)
      if search
        find(:all, 
             :select => 'DISTINCT users.*', 
             :joins => "LEFT JOIN locations ON locations.locatable_id = users.id AND locations.locatable_type = 'User'", 
             :conditions => ['users.name LIKE ? or users.email LIKE ? or locations.address LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%"]
        )
      else
        find(:all)
      end
    end    

end
