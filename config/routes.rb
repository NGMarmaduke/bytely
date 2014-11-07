Bytely::Application.routes.draw do
  devise_for :users
  root 'bytes#redirect'
  resources :bytes
  get ':byte' => 'bytes#redirect'
end
