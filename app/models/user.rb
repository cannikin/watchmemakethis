require 'digest'

class User < ActiveRecord::Base
  has_many    :sites
  belongs_to  :role
  has_many    :allowances, :through => :role
  
  validates :first_name,  :presence => true
  validates :last_name,   :presence => true
  validates :password,    :presence => true
  validates :email,       :presence => true, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }    
  validates :role_id,     :presence => true
  
  before_create :encrypt_password
  before_save   :encrypt_password, :if => lambda { self.changed.include? 'password' }
  
  
  def self.authenticate(email, password)
    User.find_by_email_and_password(email, Digest::MD5.hexdigest(password))
  end
  
  # list all the permissions for the use through the role and allowances
  def permissions
    Permission.joins(:allowances).where(:allowances => { :role_id => self.role_id})
  end
  
  
  # roles and permissions
  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      tokenize_roles(match.captures.first).each do |check|
        return true if role.name.downcase == check
      end
      return false
    elsif match = matches_dynamic_permission_check?(method_id)
      return true if self.permissions.find_by_name(match.captures.first)
    else
      super
    end
  end
  
  
  # MD5 has the password
  def encrypt_password
    self.password = Digest::MD5.hexdigest(self.password)
  end
  private :encrypt_password
  
  
  # figures out if a method_missing is a role
  def matches_dynamic_role_check?(method_id)
    /^is_an?_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end
  private :matches_dynamic_role_check?
  
  
  # figures out if a method_missing is a permission check
  def matches_dynamic_permission_check?(method_id)
    /^can_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end
  private :matches_dynamic_permission_check?


  # splits method_missing on _or_ to check multiple permissions
  def tokenize_roles(string_to_split)
    string_to_split.split(/_or_/)
  end
  private :tokenize_roles
  
end
