ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'shoulda/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_tempfile
    tempfile = Tempfile.new ['watchmemake','jpg']
    FileUtils.copy(Rails.root.join('test','unit','helpers','sample.jpg'), tempfile.path)
    return tempfile
  end
  
end
