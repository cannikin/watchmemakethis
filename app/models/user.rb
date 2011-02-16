require 'digest/md5'

class User < Sequel::Model
  many_to_one :role
  one_to_many :builds
  one_to_many :sites
  one_to_many :clients
  
  def admin?
    self.role.id == Role::ADMIN
  end
  
  def client?
    self.role.id == Role::CLIENT
  end
  
  def builds
    self.clients.collect(&:build)
  end
  
  def before_create
    super
    self.password = Digest::MD5.hexdigest(self.password)
  end
  
  def self.authenticate(params)
    where(:email => params[:email], :password => Digest::MD5.hexdigest(params[:password])).first
  end
end