class User < Sequel::Model
  one_to_many :clients
  many_to_one :user
  
  def self.authenticate(params)
    where(:email => params[:email], :password => MD5.hexdigest(params[:password])).first
  end
end