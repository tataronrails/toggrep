Toggrep::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, controllers: { confirmations: 'users/confirmations',
                                    registrations: 'users/registrations'}

  devise_scope :user do
    patch '/confirm' => 'users/confirmations#confirm'
  end

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

  namespace :toggl do
    resources :projects, only: [:index] do
      scope module: :projects do
        resources :users, only: [:index]
      end
    end
  end

  root to: 'high_voltage/pages#show', id: 'root'
end
