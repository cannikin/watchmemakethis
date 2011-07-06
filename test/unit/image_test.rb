require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  
  should belong_to :build
  should belong_to :upload_method
  
  setup do
    site = Factory.create :site
    build = Factory.create :build, :site => site
    tempfile = create_tempfile
    @image = Factory.create :image, :file => tempfile, :build => build
  end
  
  should "upload an image when creating a new image" do
    assert @image
  end
  
  
  should "provide a url" do
    assert_equal (AWS_CONFIG['s3']['cdn'] + '/' + @image.full_path_prefix + '/' + Image::META[:small][:prefix] + @image.filename), @image.url
  end
  
end
