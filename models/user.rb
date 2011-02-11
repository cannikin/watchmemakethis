require 'digest/md5'

class User < Sequel::Model
  many_to_one :role
  
  def self.authenticate(params)
    where(:email => params[:email], :password => MD5.hexdigest(params[:password])).first
  end
end