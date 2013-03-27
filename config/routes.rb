#Rails.application.routes.draw do
FatFreeCrm::Application.routes.draw do

  devise_for :users,
             :controllers => {
                 :registrations => 'fat_free_crm/registrations',
                 :sessions => 'fat_free_crm/sessions',
                 :passwords => 'fat_free_crm/passwords'}
 
  devise_scope :user do
    resources :users, :only => [:index, :show]
    get 'login', :to => 'fat_free_crm/sessions#new', :as => :new_user_session
    get 'logout', :to => 'fat_free_crm/sessions#destroy', :as => :logout
    get 'signup', :to => 'fat_free_crm/registrations#new'
    post 'signup', :to => 'fat_free_crm/registrations#create', :as => :user_registration
    get 'passwords', :to => 'fat_free_crm/passwords#new', :as => :new_user_password
    post 'passwords', :to => 'fat_free_crm/passwords#create', :as => :user_password
  end

  resources :lists

  root :to => 'fat_free_crm/home#index'

  match 'activities' => 'fat_free_crm/home#index'
  match 'admin'      => 'fat_free_crm/admin/users#index',       :as => :admin
  match 'profile'    => 'fat_free_crm/users#show',              :as => :profile

  match '/home/options',  :as => :options
  match '/home/toggle',   :as => :toggle
  match '/home/timeline', :as => :timeline
  match '/home/timezone', :as => :timezone
  match '/home/redraw',   :as => :redraw

  resources :comments

  resources :emails

  resources :accounts, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      match :auto_complete
      post :redraw
      get :versions
    end
    member do
      put  :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
      get :opportunities
    end
  end

  resources :campaigns, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      post :auto_complete
      post :redraw
      get :versions
    end
    member do
      put  :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :leads
      get :opportunities
    end
  end

  resources :contacts, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      post :auto_complete
      post :redraw
      get :versions
    end
    member do
      put  :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :opportunities
    end
  end

  resources :leads, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      post :auto_complete
      post :redraw
      get :versions
    end
    member do
      get  :convert
      post :discard
      post :subscribe
      post :unsubscribe
      put  :attach
      put  :promote
      put  :reject
    end

    get :autocomplete_account_name, :on => :collection
  end

  resources :opportunities, :id => /\d+/ do
    collection do
      get  :advanced_search
      post :filter
      get  :options
      get  :field_group
      post :auto_complete
      post :redraw
      get :versions
    end
    member do
      put  :attach
      post :discard
      post :subscribe
      post :unsubscribe
      get :contacts
    end
  end

  resources :tasks, :id => /\d+/ do
    collection do
      post :filter
      post :auto_complete
    end
    member do
      put :complete
    end
  end

  resources :users, :id => /\d+/ do
    member do
      get :avatar
      put :upload_avatar
      post :redraw
    end

    collection do
      match :auto_complete
    end
    collection do
      get :opportunities_overview
    end
  end

  namespace :admin do
    resources :groups

    resources :users do
      collection do
        post :auto_complete
      end
      member do
        get :confirm
        put :suspend
        put :reactivate
      end
    end

    resources :field_groups, :except => :index do
      collection do
        post :sort
      end
      member do
        get :confirm
      end
    end

    resources :fields do
      collection do
        post :auto_complete
        get :options
        post :redraw
        post :sort
        get :subform
      end
    end

    resources :tags do
      member do
        get :confirm
      end
    end

    resources :fields, :as => :custom_fields
    resources :fields, :as => :core_fields

    resources :settings
    resources :plugins
  end

  get '/:controller/tagged/:id' => '#tagged'
end
