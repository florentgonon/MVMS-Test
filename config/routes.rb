Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :first_reporting, only:[:index]
  resources :second_reporting, only:[:index]
  resources :third_reporting, only:[:index]
end
