Hozr::Application.routes.draw do
  # Main page
  root :to => 'search#index'

  # Authentication
  devise_for :users
  resources :users

  match 'order_form/print' => 'order_form#print', :format => 'pdf'
  match '/:controller(/:action(/:id))'
end
