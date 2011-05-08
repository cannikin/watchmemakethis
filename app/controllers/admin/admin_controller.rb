class Admin::AdminController < ApplicationController
  
  before_filter :build_nav#, admin_required
  layout 'admin'
  
  def build_nav
    @nav = [  ['Dashboard',   admin_home_path,          'admin/home'],
              ['Builds',      admin_builds_path,        'admin/builds'],
              ['Clients',     admin_clients_path,       'admin/clients'],
              ['Permissions', admin_permissions_path,   'admin/permissions'],
              ['Roles',       admin_roles_path,         'admin/roles'],
              ['Sites',       admin_sites_path,         'admin/sites'],
              ['Users',       admin_users_path,         'admin/users']
              #['API',
              #  ['Documentation',       admin_api_path,                   'admin/api'],
              #  ['Keys',                admin_keys_path,                  'admin/keys'],
              #],
          ]
  end
  private :build_nav
  
end