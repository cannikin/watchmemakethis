class SiteController < ApplicationController
  
  before_filter :get_site_and_build
  
  layout 'site'

  def show
    @page_title = @site.name
  end

  
end
