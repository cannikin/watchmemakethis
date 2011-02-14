require 'digest/md5'

class Client < Sequel::Model
  many_to_one :user
  many_to_one :build
  
  def before_create
    self.password = Digest::MD5.hexdigest(self.password)
  end
  
  def self.authenticate(params)
    where(:email => params[:email], :password => Digest::MD5.hexdigest(params[:password])).first
  end
end