PngHivAids::Application.routes.draw do

  namespace :admin do
    resources :import_survs do
      resources :surv_sites
      member do
        get 'download'
      end
    end

    resources :surv_sites do
      resources :surv_site_commodities
    end

    resources :orders do
      collection do
        get 'tab_order_line'
      end
      resources :order_lines
    end
    resources :requisition_reports do
      member do
        post 'import'
        get  'download'
      end
    end
    resources :home
    
    resources :sites do
      resources :requisition_reports
      member do
        get 'users'
      end
    end

    resources :provinces
    resources :commodities
    resources :public_holidays
    resources :settings
    resources :categories
    resources :commodity_categories do
      collection do
        get 'template'
      end
    end
    resources :units
    resources :users do

      member do
        get 'reset'   # reset_admin_user_path /admin/users/:id/reset
        put 'change'
      end

      collection do
        get 'account' # account_admin_users_path /admin/users/account
      end

    end
    root :to => 'dashboards#index'
    # root :to => 'home#index'
    # root :to => 'commodities#index', :type => "drugs"
  end

  devise_for :users
  devise_scope :user do
    get "sign_in", :to => "devise/sessions#new"
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :homes
  
  root  :to => "homes#index"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
