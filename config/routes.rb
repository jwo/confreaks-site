Confreaks::Application.routes.draw do
  # dispcal '/calendar/:year/:month',
  # :controller => 'calendar',
  # :action => 'index',
  # :requirements => {:year => /\d{4}/, :month => /\d{1,2}/},
  # :year => Time.zone.now.year,
  # :month => Time.zone.now.month

  root :controller => "main", :action => "home_page"

  match '/terms-of-service', :to => "main#tos", :as => 'terms_of_service'
  match '/privacy-policy', :to => "main#privacy", :as => 'privacy_policy'
  match '/contact-us', :to => "main#contact_us", :as => 'contact_us'
  match '/contact', :to => "main#contact", :as => 'contact'
  match '/about-us', :to => "main#about_us", :as => 'about_us'
  match '/services', :to => "main#services", :as => 'services'
  match '/blog', :to => 'blog#index', :as => 'blog'
  match '/events/missing', :to => "events#missing_event", :as => 'missing_event'

  match "/redirects/:redirect_id/videos/videos/:id.mp4", :to => 'redirects#file_redirect' # FIXME: this one ain't tested!

  match "/admin", :to => 'admin/root#index', :as => 'admin'
  # namespace :admin do
  #   attach    '/videos/attach/:id',
  #                        :controller => :videos,
  #                        :action => "attach"
  #   encode    '/assets/encode/:id',
  #                        :controller => :assets,
  #                        :action => "encode"
  #   encode_small '/assets/encode_small/:id',
  #                        :controller => :assets,
  #                        :action => "encode_small"
  #   refresh  '/assets/refresh/:id',
  #                        :controller => :assets,
  #                        :action => 'refresh_meta_data'

  #   resources :videos
  #   resources :events do
  #     resources :videos do
  #       resources :assets
  #     end
  #   end
  
  #   resource  :session, :member => { :reset => [:get, :post] }
  #   resources :events, :member => { :missing_event => [:get] }
  #   resources :redirects do
  #     resources :videos, :controller => 'redirects'
  #   end
  #   resources :videos do
  #     resources :assets
  #   end
  #   resources :feeds, :only => [:index, :show]
  #   resources :presenters
  #   resources :users
  #   resources :conferences
  #   resources :presenters
  #   resources :conferences
  #   resources :users
  #   resources :asset_types
  #   resources :assets
  # end

  # zc_callback '/zc-callback',
  #                :controller => 'admin/videos',
  #                 :action => 'callback',
  #                 :method => ['post','get']


###
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
