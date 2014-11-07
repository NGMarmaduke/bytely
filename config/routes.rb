Bytely::Application.routes.draw do
  root 'bytes#redirect'
  resources :bytes
  get ':byte' => 'bytes#redirect'
end
