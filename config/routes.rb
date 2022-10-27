Rails.application.routes.draw do
  devise_for :users
  root to: 'top_pages#top_page'
  resources :users, only: :show
  resources :fields, only:[:index, :new, :create, :update, :destroy] do
    resources :votes, only:[:new, :create]
    get 'vote/thanks', to: 'votes#thanks'
    resources :oogiris, only:[:index, :new, :create, :edit, :update, :show, :destroy] do
      resources :comments, only:[:create, :destroy] do
        resources :comment_likes, only:[:create, :destroy]
      end
    end
    get '/oogiri/:id/votes', to: 'oogiris#vote_show'
  end
  resources :comments, only:[:index]
  get 'fields/now_field', to: 'fields#now_field_index'
  get '/admin/top', to: 'admin/admins#top'
  get '/ranking', to: 'top_pages#ranking'
  get '/privacy_policy', to: 'top_pages#privacy_policy'
  get '/minus_oogiris/', to: 'top_pages#minus_oogiris'
end