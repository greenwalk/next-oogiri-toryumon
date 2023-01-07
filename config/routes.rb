Rails.application.routes.draw do
  devise_for :users
  root to: 'top_pages#top_page'
  resources :users, only: [:index, :show] do
    member do
      get :registration_twitter, to: 'users#registration_twitter_edit'
      patch :registration_twitter, to: 'users#registration_twitter_update'
    end
  end
  resources :user_monsters, only: :create
  post 'user_monsters/update', to: 'user_monsters#update'

  get 'fields/now_field', to: 'fields#now_field_index'
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

  # 滝壺
  get 'basin_fields/now_basin_field', to: 'basin_fields#now_basin_field'
  resources :basin_fields, only:[:index] do
    get '/basin_votes', to: 'basin_oogiris#vote'
    resources :basin_oogiris, only:[:index, :new, :create, :destroy] do
      resources :basin_likes, only:[:create, :destroy]
    end
  end

  get 'basin_theme_adjectives/upload', to: 'basin_theme_adjectives#upload'
  post 'basin_theme_adjectives/import', to: 'basin_theme_adjectives#import'
  get 'basin_theme_nouns/upload', to: 'basin_theme_nouns#upload'
  post 'basin_theme_nouns/import', to: 'basin_theme_nouns#import'

  resources :comments, only:[:index]

  get '/admin/top', to: 'admin/admins#top'
  post '/admin/update_toryu_setting', to: 'admin/admins#update_toryu_setting'
  get '/ranking', to: 'top_pages#ranking'
  get '/ban', to: 'top_pages#ban'
  get '/privacy_policy', to: 'top_pages#privacy_policy'
  get '/minus_oogiris/', to: 'top_pages#minus_oogiris'
end