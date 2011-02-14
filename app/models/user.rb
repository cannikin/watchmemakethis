require 'digest/md5'

class User < Sequel::Model
  many_to_one :role
  one_to_many :builds
  one_to_many :sites
  
  def before_create
    self.password = Digest::MD5.hexdigest(self.password)
  end
  
  def self.authenticate(params)
    where(:email => params[:email], :password => Digest::MD5.hexdigest(params[:password])).first
  end
end