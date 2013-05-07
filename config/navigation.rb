# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|
    if user_signed_in?
      primary.item :admin_work_queue, 'TODO', admin_work_queue_path
      primary.item :entry, 'Eingang', '#' do |entry|
        entry.item :new_case_assignments, 'Auftragsformulare', new_case_assignments_path
        entry.item :first_entry_queue_cases, 'Ersteingabe', first_entry_queue_cases_path
        entry.item :new_patient, 'Patient erfassen', new_patient_path
      end
      primary.item :edit, 'Bearbeitung', '#' do |edit|
        edit.item :second_entry_queue_cases, 'Zweiteingabe', second_entry_queue_cases_path
        edit.item :hpv_p16_queue_cases, 'HPV/P16', hpv_p16_queue_cases_path
        edit.item :review_queue_cases, 'Review', review_queue_cases_path
      end
      primary.item :print, 'Drucken', '#' do |print|
        print.item :doctor_order_form, 'Auftragsformular Drucken', doctor_order_form_path, :link => {:remote => true}
        print.item :case_label_print, 'Objektträger Etiketten', case_label_print_path, :link => {:remote => true}
        print.item :case_list_print, 'HPV/P16 Liste', case_list_print_path, :method => :post, :link => {:remote => true} if current_tenant.settings['modules.p16']
        print.item :p16_case_label_print, 'P16 Etiketten', p16_case_label_print_path, :method => :post, :link => {:remote => true} if current_tenant.settings['modules.p16']
        print.item :post_label_print, 'Packet Etiketten', post_label_print_path, :link => {:remote => true}
      end
      primary.item :search, 'Suche', '#' do |search|
        search.item :cases, 'Fälle', cases_path
        search.item :divider, "", :class => 'divider'
        search.item :patients, 'Patienten', patients_path
        search.item :doctors, 'Ärzte', doctors_path
        search.item :people, 'Alle Personen', people_path
      end
      primary.item :administration, 'Administration', '#' do |administration|
        administration.item :reports, 'Statistiken', reports_path
        administration.item :divider, "", :class => 'divider'
        administration.item :order_forms, 'Auftragsformulare', order_forms_path
        administration.item :send_queues, 'Resultat Queue', send_queues_path
        administration.item :fax_queue, t_title(:index, Fax), faxes_path
        administration.item :divider, "", :class => 'divider'
        administration.item :dunning_stopped_patients, 'Patienten mit Mahnstopp', dunning_stopped_patients_path
        administration.item :classifications, 'Klassifikationen', classifications_path
        administration.item :classification_groups, 'Klassifikationsgruppen', classification_groups_path
        administration.item :finding_classes, 'Befunde', finding_classes_path
        administration.item :examinations_methods, 'Methoden', examination_methods_path
        administration.item :divider, "", :class => 'divider'
        administration.item :attachments, t_title(:index, Attachment), tenant_attachments_path(current_tenant)
        administration.item :employees, 'Mitarbeiter', employees_path
        administration.item :current_tenant, t_model(Tenant), current_tenants_path
        administration.item :users, t_model(User), users_path
      end
    end
  end
end
