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

  # Main resources
  resources :doctors

  resources :patients do
    collection do
      post :search
      get :dunning_stopped
    end
  end

  resources :cases do
    collection do
      get :first_entry_queue, :second_entry_queue, :hpv_p16_queue, :review_queue
      get :unassigned_form
      get :autocomplete_finding_class_code
    end

    member do
      delete :destroy_from_assign
      post :set_patient
      get :set_new_patient
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

  # Form Printing
  match 'order_form' => 'order_form#index', :as => :order_form
  match 'order_form/print' => 'order_form#print', :as => :print_order_form

  # Search
  post 'search/search' => 'search#search'

  # Reports
  get 'reports' => 'reports#index'
  post 'reports/search' => 'reports#search'

  # Slidepath
  match 'slidepath/links' => 'slidepath#links'
  match 'slidepath/scanned_cases' => 'slidepath#scanned_cases'

  match '/:controller(/:action(/:id))'
end
