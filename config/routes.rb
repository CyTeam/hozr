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

  post 'search/search' => 'search#search'

  resources :patients do
    collection do
      post :search
    end
  end

  resources :cases do
    collection do
      get :second_entry_queue, :hpv_p16_queue, :review_queue
      get :unassigned_form
    end

    member do
      post :hpv_p16_prepared
      post :add_finding
      delete :remove_finding
      get :edit_finding_text
      post :update_finding_text
    end
  end

  resources :order_forms do
    member do
      get :head_big, :head_small
    end
  end

  # Slidepath
  match 'slidepath/links' => 'slidepath#links'
  match 'slidepath/scanned_cases' => 'slidepath#scanned_cases'

  match '/:controller(/:action(/:id))'
end
