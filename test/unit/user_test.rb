require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should have_many  :sites
  should belong_to  :role
  should have_many  :allowances
  should have_many  :builds
  
  # should validate_presence_of   :password
  # should validate_presence_of   :email
  # should validate_uniqueness_of :email
  # should validate_format_of     :email
  # should validate_presence_of   :role_id
  
  context "before saving a user to the database" do
    
    should "encrypt the password before creation" do
      @user = Factory.build :user
      
      assert_nil @user.password
      @user.password = 'password'
      @user.save
      assert_equal Digest::MD5.hexdigest('password'), @user.password
    end
    
    should "create a uuid before creation" do
      @user = Factory.build :user, :password => 'password'
      assert_nil @user.uuid
      @user.save
      assert_not_nil @user.uuid
    end
    
    should "encrypt the password before save when changed" do
      @user = Factory.create :user, :password => 'password'
      assert_not_nil @user.password                       # user has a password
      old_password = @user.password
      @user.password = 'new_password'
      @user.save
      assert_not_equal old_password, @user.password
      assert_equal Digest::MD5.hexdigest('new_password'), @user.password     # password isn't the input string any more
    end
    
    should "not encrypt the password before safe when it hasn't changed" do
      @user = Factory.create :user, :password => 'password'
      @user.first_name = 'Tom'
      existing_password = @user.password
      @user.save
      assert_equal existing_password, @user.password
    end
    
  end
  
  context "authenticating a user" do
    
    setup do
      @user = Factory.create(:user, :password => 'password')
    end
    
    should 'succeed with a valid password' do
      assert User.authenticate(@user.email, 'password')
    end
  
    should 'fail with an invalid password' do
      assert_nil User.authenticate(@user.email, 'invalid')
    end
    
    should 'fail with an invalid email' do
      assert_nil User.authenticate(Faker::Internet.email, 'password')
    end
    
  end
  
end
