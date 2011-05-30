class MarketingController < ApplicationController
  
  caches_page :index
  
  def index
  end

  def help
    @page_title = 'Help'
  end
  
  def echo
    foo = request.env.dup
    render :json => foo.env.keys
  end

end
