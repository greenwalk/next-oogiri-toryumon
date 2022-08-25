Rails.application.routes.draw do
  devise_for :users
  root to: 'top_pages#top_page'
end