Rails.application.routes.draw do
  devise_for :users
  root to: 'top_pages#top_page'
  get '/admin/top', to: 'admin/admins#top'
end