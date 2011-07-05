require 'test_helper'

class BuildTest < ActiveSupport::TestCase
  
  setup do
    @validation_build = Factory.create :build, :path => 'validation_build', :hashtag => 'validation_build', :public => true
  end
  
  should belong_to    :site
  should have_many    :clients
  should have_many    :images
  
  should validate_presence_of   :name
  should validate_presence_of   :path
  #should validate_length_of(:path).is_at_least(1).is_at_most(32)
  should validate_format_of(:path).with('nightstand')
  should validate_format_of(:path).with('night-stand')
  should validate_format_of(:path).with('night_stand')
  should validate_format_of(:path).not_with('night.stand').with_message("is invalid")
  should validate_format_of(:path).not_with('night stand').with_message("is invalid")
  should validate_uniqueness_of  :path
  #should validate_length_of(:hashtag).is_at_least(1).is_at_most(32)
  should validate_uniqueness_of :hashtag
  should validate_format_of(:hashtag).with('nightstand')
  should validate_format_of(:hashtag).with('night-stand')
  should validate_format_of(:hashtag).with('night_stand')
  should validate_format_of(:hashtag).not_with('night.stand').with_message("is invalid")
  should validate_format_of(:hashtag).not_with('night stand').with_message("is invalid")
  
  setup do
    @public_build = Factory.create :build, :path => 'public', :hashtag => 'public', :public => true
    @private_build = Factory.create :build, :path => 'private', :hashtag => 'private', :public => false
  end
  
  should "have a scope that returns public builds only" do
    assert_equal [@validation_build, @public_build], Build.publics
  end
  
  should "have a scope that returns private builds only" do
    assert_equal [@private_build], Build.privates
  end

end
