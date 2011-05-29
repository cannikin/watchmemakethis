Watchmemakethis::Application.routes.draw do

  get '/admin' => 'admin/home#index', :as => :admin_home

  namespace :admin do
    resources :builds
    resources :clients
    resources :images
    resources :permissions
    resources :roles
    resources :sites
    resources :styles
    resources :users
  end
  
  controller :marketing do
    get '/'     => :index
    get '/echo' => :echo
  end
  
  controller :session do
    get   '/login'    =>  :new
    post  '/login/go' =>  :create
    get   '/logout'   =>  :destroy
  end
  
  controller :signup do
    get   '/signup'     => :new
    post  '/signup/go'  => :create
  end
  
  controller :help do
    get   '/help'       => :index
  end
  
  controller :site_admin do
    get '/:site_path/admin' => :index, :as => :site_admin
  end
  
  controller :site do
    get '/:site_path'         => :show,   :as => :site
    get '/:site_path/edit'    => :edit,   :as => :edit_site
    put '/:site_path/update'  => :update, :as => :update_site
  end
  
  controller :build do
    get     '/:site_path/builds'              => :index
    get     '/:site_path/builds/new'          => :new,            :as => :new_build
    post    '/:site_path/builds/create'       => :create,         :as => :create_build
    get     '/:site_path/:build_path'         => :show,           :as => :build
    post    '/:site_path/:build_path/upload'  => :upload,         :as => :build_upload
    get     '/:site_path/:build_path/:id'     => :image,          :as => :image
    put     '/:site_path/:build_path/:id'     => :update_image,   :as => :image
    delete  '/:site_path/:build_path/:id'     => :destroy_image,  :as => :image
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "marketing#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
