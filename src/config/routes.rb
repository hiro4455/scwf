Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :requests do
    member do
      get :review
      post :approve
    end
  end

end
