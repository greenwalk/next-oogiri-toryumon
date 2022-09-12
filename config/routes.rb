Rails.application.routes.draw do
  devise_for :users
  root to: 'top_pages#top_page'
  resources :fields, only:[:index, :create, :update] do
    resources :oogiris, only:[:index, :new, :create, :edit, :update, :show, :destroy] do
      resources :comments, only:[:create, :destroy]
    end
  end
  resources :votes, only:[:new, :create]
  get '/vote/thanks', to: 'votes#thanks'
  get '/admin/top', to: 'admin/admins#top'
  get '/ranking', to: 'top_pages#ranking'
end