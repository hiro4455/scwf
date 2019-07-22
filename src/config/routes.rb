Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # login / logout
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'login', to: 'sessions#destroy'

  # operate request
  resources :requests do
    member do
      get :review
      get :confirm
      post :apply
      post :approve
    end
  end

end
