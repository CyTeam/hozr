# encoding: UTF-8

Hozr::Application.routes.draw do
  # Main page
  root :to => 'work_queue#admin'

  # Authentication
  devise_for :users
  resources :users do
    member do
      post :lock, :unlock
    end
    resources :phone_numbers
    member do
      get :new_phone_number
    end
    collection do
      get :new_phone_number
    end
  end

  # Attachments
  resources :attachments do
    member do
      get :download
    end
  end

  # Tenant
  resources :tenants do
    collection do
      get :current
    end
  end

  # Main resources

  resources :doctors do
    resources :phone_numbers
    member do
      get :new_phone_number
    end
    collection do
      get :new_phone_number
    end
  end

  resources :employees do
    resources :phone_numbers
    member do
      get :new_phone_number
    end
    collection do
      get :new_phone_number
    end
  end

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

  namespace :case do
    resource :assignments

    namespace :label do
      get :new
      post :print
    end
  end

  resources :cases do
    resources :patients, :module => 'case'

    collection do
      get :first_entry_queue, :second_entry_queue, :hpv_p16_queue, :review_queue
      get :unassigned_sort_queue, :unassigned_form, :assignings_list
      post :assign
    end

    member do
      get :report
      get :next_step

      delete :destroy_from_assign
      post :hpv_p16_prepared
      post :create_hpv_p16_for_case
      post :review_done

      post :print_result_report

      get :first_entry, :second_entry_pap_form, :second_entry_form
      get :sign
      get :next_first_entry

      post :second_entry_form
      put :second_entry_update
      post :sign

      post :resend
    end
  end

  resources :send_queues do
    collection do
      get :print_all
    end

    member do
      post :print
    end
  end

  resources :mailings do
    member do
      post :send_by, :send_by_all_channels
      post :print_overview
      post :print_result_reports
      get :overview
    end

    collection do
      post :generate
      post :send_all
      post :print_all
    end
  end

  resources :classifications
  resources :classification_groups
  resources :finding_classes
  resources :examination_methods

  resources :order_forms do
    collection do
      post :scan
    end
    member do
      get :head_image
      get :download, :inline
    end
  end

  # Form Printing
  get 'doctor_order_form' => 'doctor_order_form#form', :as => :doctor_order_form
  post 'doctor_order_form' => 'doctor_order_form#print', :as => :doctor_order_form

  # Label Printing
  # get 'case_label_print' => 'case_label_print#form', :as => :case_label_print
  # post 'case_label_print' => 'case_label_print#print', :as => :case_label_print
  post 'p16_case_label_print' => 'case_label_print#print_p16', :as => :p16_case_label_print
  post 'case_label_print/:id' => 'case_label_print#print_case', :as => :print_case_label

  get 'post_label_print' => 'post_label_print#form', :as => :post_label_print
  post 'post_label_print' => 'post_label_print#print', :as => :post_label_print


  # Search
  match 'search' => 'search#index', :as => :search

  # Reports
  get 'reports' => 'reports#index'
  post 'reports/search' => 'reports#search', :as => :search_reports

  # Slidepath
  match 'slidepath/links' => 'slidepath#links'
  match 'slidepath/scanned_cases' => 'slidepath#scanned_cases'

  # WorkQueue
  get 'work_queue/admin' => 'work_queue#admin', :as => :admin_work_queue
end
