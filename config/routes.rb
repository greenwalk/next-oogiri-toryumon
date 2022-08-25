Rails.application.routes.draw do
  devise_for :users
  root to: 'top_pages#top_page'
  resources :fields, only:[:index, :create]
  get '/admin/top', to: 'admin/admins#top'
end