Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :api, defaults: { format: :json } do
    resources :symptoms, only: [:show, :create] do
      get :image, on: :member
    end
  end
end
