Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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
  end
end
