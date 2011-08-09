Hozr::Application.routes.draw do
  devise_for :users

  root :to => 'search#index'
  match 'order_form/print' => 'order_form#print', :format => 'pdf'
  match '/:controller(/:action(/:id))'
end
