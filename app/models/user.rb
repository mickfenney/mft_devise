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
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  phone                  :string(255)
#  theme                  :string(255)      default("default")
#  image                  :string(255)
#  is_image               :boolean          default(FALSE)
#

class User < ActiveRecord::Base

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :async 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :name, :email, :phone, :password, :password_confirmation, :remember_me, :locations, :theme, :is_image, :image, :remote_image_url, :locations_attributes, :as => :admin
  attr_accessible :name, :email, :phone, :password, :password_confirmation, :remember_me, :locations, :theme, :is_image, :image, :remote_image_url, :locations_attributes

  mount_uploader :image, GravatarUploader

  enumerate :theme, :with => ThemeEnum

  validates_presence_of :name, :theme
  #validates_uniqueness_of :name

  has_many :locations, :as => :locatable

  has_many :documents

  accepts_nested_attributes_for :locations, allow_destroy: true

  before_validation strip_attributes :except => [:phone, :password, :password_confirmation]

  validates_inclusion_of :theme, :in => ThemeEnum

  validates :name, :length => { :maximum => 255 }
  validates :email, :length => { :maximum => 255 }
  validates :phone, :length => {:minimum => 8, :maximum => 12}, :allow_blank => true

  after_create :assign_default_role
  after_save :assign_default_role

  after_destroy :remove_id_directory
  after_save :remove_tmp_directory  

  ### TODO: test is passing when it should not pass
  # # devise_invitable accept_invitation! method overriden
  # def accept_invitation!
  #   #logger.debug 'accept_invitation called'
  #   self.confirm! 
  #   super
  # end

  # devise_invitable invite! method overriden
  def invite!
    #logger.debug 'invite called'
    self.confirm!
    super
    #self.confirmed_at = Time.now
    #self.save
  end  

  def phone=(num)
    num.gsub!(/\D/, '') if num.is_a?(String)
    super(num)
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end  

  protected

    def remove_id_directory
      FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/user/image/#{id}", :force => true)
    end

    def remove_tmp_directory
      FileUtils.remove_dir("#{Rails.root.to_s}/public/uploads/tmp", :force => true)
    end  

  private

    def assign_default_role
      unless has_role? :admin
        add_role(:user)
      end
    end

    def self.search(search)
      if search
        select('DISTINCT users.*')
        .joins("LEFT JOIN locations ON locations.locatable_id = users.id AND locations.locatable_type = 'User'")
        .where('users.name LIKE ? or users.email LIKE ? or locations.address LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
      else
        scoped
      end
    end    

end
