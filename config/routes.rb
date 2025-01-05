Rails.application.routes.draw do
  devise_for :users
  root 'posts#index' # rootをposts#indexに変更

  resources :posts, only: %i[new create show index destroy edit update]
end
