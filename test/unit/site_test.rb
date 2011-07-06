require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  
  setup do
    Factory.create :site, :path => 'validation_site'
  end
  
  should have_many  :builds
  should belong_to  :user
  should belong_to  :style
  
  should validate_presence_of   :name
  # should validate_length_of(:name).is_at_least(1).is_at_most(32)
  should validate_presence_of   :path
  should validate_uniqueness_of(:path).with_message('This URL is already taken, please try another.')
  # should validate_length_of(:path).is_at_least(1).is_at_most(32)
  # should validate_exclusion_of  :path, :in => %w{admin api blog build forgot help images info login logout pricing reset signup site style styles theme themes}, :message => 'This URL is reserved, please try another.' 
  should validate_format_of(:path).with('nightstand')
  should validate_format_of(:path).with('night-stand')
  should validate_format_of(:path).with('night_stand')
  should validate_format_of(:path).not_with('night.stand').with_message('Your site name may only include letters, numbers, _underscores_ and -dashes-')
  should validate_format_of(:path).not_with('night stand').with_message('Your site name may only include letters, numbers, _underscores_ and -dashes-')
  should validate_format_of(:path).not_with('http://example.com').with_message('Your site name may only include letters, numbers, _underscores_ and -dashes-')
  
  should "have an alias of user called owner" do
    site = Factory.create(:site, :user => Factory.create(:user))
    assert_equal site.user, site.owner
  end
  
end
