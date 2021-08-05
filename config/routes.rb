Rails.application.routes.draw do
  resources :posts do
    member do
      patch "upvote", to: "posts#upvote"
    end
    # post 'comments', to: 'comments#create'
    resources :comments, only: [:create, :destroy]
  end

  devise_for :users , post: 'users'

  get 'welcome/index'
  get '/search', to: 'posts#search'
  root 'welcome#index'

  get '/story', to: 'welcome#story'

  resource :friendships, only: [:create , :destroy]
end
