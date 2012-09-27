Hozr::Application.routes.draw do
  # Main page
  root :to => 'work_queue#admin'

  # Authentication
  devise_for :users
  resources :users do
    member do
      post :lock, :unlock
    end
  end

  # Main resources
  resources :doctors
  resources :employees

  resources :patients do
    collection do
      get :dunning_stopped
      get :propose_merge
      post :merge
    end
    member do
      get :show_history
    end
  end

  resources :cases do
    resources :patients, :module => 'case'

    collection do
      get :first_entry_queue, :second_entry_queue, :hpv_p16_queue, :review_queue
      get :unassigned_sort_queue, :unassigned_form, :assignings_list
      get :autocomplete_finding_class_code
      post :assign
    end

    member do
      delete :destroy_from_assign
      post :hpv_p16_prepared
      post :add_finding
      delete :remove_finding
      get :edit_finding_text
      post :update_finding_text
      post :print_result_report
      post :create_hpv_p16_for_case
      post :review_done

      get :first_entry, :second_entry_pap_form, :second_entry_form, :result_report
      get :sign
      get :next_first_entry

      post :resend
    end
  end

  resources :send_queues do
    collection do
      get :list_open
      get :print_all
    end

    member do
      post :print
    end
  end

  resources :mailings do
    member do
      post :send_by
    end

    collection do
      post :generate
      post :send_all
      post :print_all
      get :list_open
    end
  end

  resources :classifications
  resources :classification_groups
  resources :top_finding_classes
  resources :finding_classes

  resources :order_forms do
    member do
      get :head_image
      get :download, :inline
    end
  end

  # Form Printing
  match 'doctor_order_form' => 'doctor_order_form#index', :as => :doctor_order_form
  match 'doctor_order_form/print' => 'doctor_order_form#print', :as => :print_doctor_order_form

  # Label Printing
  get 'label_print/case_label' => 'label_print#case_label', :as => :case_label_label_print
  get 'label_print/case_label_single' => 'label_print#case_label_single', :as => :case_label_single_label_print
  post 'label_print/case_label_p16' => 'label_print#case_label_p16', :as => :case_label_p16_label_print
  get 'label_print/post_label' => 'label_print#post_label', :as => :post_label_label_print
  post 'label_print/post_label' => 'label_print#post_label_print', :as => :post_label_print_label_print

  # Search
  match 'search' => 'search#index', :as => :search

  # Reports
  get 'reports' => 'reports#index'
  post 'reports/search' => 'reports#search'

  # Slidepath
  match 'slidepath/links' => 'slidepath#links'
  match 'slidepath/scanned_cases' => 'slidepath#scanned_cases'

  # WorkQueue
  get 'work_queue/admin' => 'work_queue#admin', :as => :admin_work_queue
end
