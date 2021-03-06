PngHivAids::Application.routes.draw do

  match "/401", to: "errors#unauthorized_401"
  match "/404", to: "errors#not_found_404"
  match "/500", to: "errors#error_500"

  namespace :service do
    resource :messagings do
      post 'nuntium'
    end

  end

  namespace :admin do

    resources :lab_test_categories
    resources :regimen_categories
    resources :lab_tests
    resources :regimens

    resources :order_status, only: [:index]

    resources :site_messages do
      collection do
        get 'all'
      end
    end

    resources :import_survs do
      resources :surv_sites
      member do
        get 'download'
        get 'view'
      end
    end

    resources :surv_sites do
      resources :surv_site_commodities
    end

    resources :sms_logs do
      collection do
        get 'monitor'
      end
    end

    resources :shipments do

      resources :site_messages do
        collection do
          get 'shipment_messages'
        end
      end
      resources :sms_logs

      collection do
        get 'download'
        get 'order'
        post 'add_session'
        put 'mark_status'
        delete 'remove_session'
        post 'create_shipment'
      end

      member do
        post 'update_cost'
      end

    end

    resources :orders do
      #resources :shipments
      collection do
        get 'tab_order_line'
        get 'export'
        get 'export_excel'
      end

      member do
        get 'review'
        put 'reject'
        put 'unreject'
      end

      resources :order_lines do
        member do
          put 'reject'
          put 'approve'
        end

        collection do
          put 'approve_all'
        end
      end
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
      resources :site_messages
      member do
        get 'users'
      end
    end


    resources :provinces
    resources :commodities do
      collection do
        put :reorder
      end
    end
    resources :public_holidays
    resources :settings
    resources :categories
    resources :commodity_categories do
      collection do
        get 'template'
        put :reorder
      end
    end
    resources :units
    resources :users do
      member do
        put 'reset'
      end

      collection do
        get 'account' # account_admin_users_path /admin/users/account
        get 'new_password'
        put 'change'
        get 'profile'
        put 'update_profile'
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
