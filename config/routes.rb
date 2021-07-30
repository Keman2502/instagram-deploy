Rails.application.routes.draw do
  resources :posts
  devise_for :users , post: 'users'
  get 'welcome/index'
  root 'welcome#index'

end
