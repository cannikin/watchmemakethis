# handles displaying the site and the client's page
# client homepage
get '/:site_path/:build_path' do
  if @site = find_site(params[:site_path])
    if @build = find_build(params[:build_path], @site)
      @build.increment_views
      haml :'site/build'
    else
      not_found
    end
  else
    not_found
  end
end


# site homepage
get '/:site_path' do
  if @site = find_site(params[:site_path])
    @public_clients = @site.builds.select { |b| b.public and !b.archived }
    haml :'site/index'
  else
    not_found
  end
end


# stylesheets for a site
get '/stylesheets/:site_path.css' do
  if @site = find_site
    sass :'site/styles.sass'
  else
    not_found
  end
end
