Hozr::Application.routes.draw do
  # Main page
  root :to => 'search#index'

  # Authentication
  devise_for :users
  resources :users do
    member do
      post :lock, :unlock
    end
  end

  match 'order_form/print' => 'order_form#print', :format => 'pdf'
  match '/:controller(/:action(/:id))'

  # Slidepath
  match 'slidepath/links' => 'slidepath#links'
end
