require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    Factory.create :user, :email => 'jane.doe@anonymous.com'
  end
  
  should have_many  :sites
  should belong_to  :role
  should have_many  :allowances
  should have_many  :builds
  
  should validate_presence_of   :password
  should validate_presence_of   :email
  should validate_uniqueness_of :email
  should validate_format_of(:email).with('john.doe@example.com')
  should validate_format_of(:email).not_with('john.doe@example').with_message("This isn't a valid email address: it should be in the form of <em>johndoe@anonymous.com</em>")
  should validate_presence_of   :role_id
  
  context "before saving a user to the database" do
    
    should "encrypt the password before creation" do
      @user = Factory.build :user, :password => 'password'
      
      assert_equal 'password', @user.password
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
  
  should "have a method to return all images in all builds" do
    user = Factory.create :user
    site = Factory.create :site, :user => user
    build = Factory.create :build, :site => site
    tempfile = Tempfile.new ['watchmemake','jpg']
    FileUtils.copy(Rails.root.join('test','unit','helpers','sample.jpg'), tempfile.path)
    image = Factory.create :image, :file => tempfile, :build => build
    
    assert_equal [image], user.images
  end
  
end
