Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: "home#index"

  scope :api, defaults: { format: :json } do 
    devise_scope :user do
      devise_for :users,   only: []
      post   'register',   to: 'auth/registrations#create'
      post   'login',      to: 'auth/sessions#create'
      delete 'logout',     to: 'auth/sessions#destroy'
      put    'credential', to: 'auth/credentials#update'
    end
    # _ END OF DEVISE _ #

    resources :users do
      resources :symptoms, only: [:index, :show, :new, :create] do
        get :image, on: :member
      end  
    end

    # TODO:
    # Catch-all to allow proper HTTP responses for 405 and 501
    match "register", :to => "application#route_not_found", via: [:options, :get, :head, :put, :delete, :patch]
    match "login", :to => "application#route_not_found", via: [:options, :get, :head, :put, :delete, :patch]
    match 'logout',     :to => 'application#route_not_found', via: [:options, :get, :head, :put, :patch, :post]
    match 'credential', :to => 'application#route_not_found', via: [:options, :get, :head, :patch, :post, :delete]

  end

end

# [:options, :get, :head, :post, :put, :delete, :trace, :connect, :propfind, :proppatch, :mkcol, :copy, :move, :lock, :unlock, :"version-control", :report, :checkout, :checkin, :uncheckout, :mkworkspace, :update, :label, :merge, :"baseline-control", :mkactivity, :orderpatch, :acl, :search, :mkcalendar, :patch]