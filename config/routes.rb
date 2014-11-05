Toggrep::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users, controllers: { sessions: "sessions" }

  resources :users, :only => [:edit, :show, :update, :destroy] do
    User::ROLES.each do |role|
      namespace role, module: nil, shallow_path: nil, role: role do
        resources :agreements, only: :index do
          collection do
            Agreement::FILTERS.each do |filter|
              get ':filter',
                :action => :index, :as => filter, filter => true,
                :constraints => { :filter => filter }
            end
          end
        end
      end
    end
  end

  resources :agreements, except: :index do
    member do
      get :accept, :reject, :cancel
    end
  end

  scope :toggl do
    get :project_users, to: 'toggl_projects#project_users'
    get :projects, to: 'toggl_projects#projects'
    get :workspaces, to: 'toggl_workspaces#index'
  end

  root :to => 'high_voltage/pages#show', id: 'root'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
