Rails.application.routes.draw do
  devise_for :users
  root 'todos#index' # rootをposts#indexに変更

  resources :posts, only: %i[new create show index destroy edit update]
  resources :todos

end
