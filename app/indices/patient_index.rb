ThinkingSphinx::Index.define :patient, :with => :active_record, :delta => true do
  indexes birth_date

  indexes vcard.full_name
  indexes vcard.nickname
  indexes vcard.family_name, :as => :family_name, :sortable => true
  indexes vcard.given_name, :as => :given_name, :sortable => true
  indexes vcard.additional_name
  indexes vcard.address.street_address
  indexes vcard.address.postal_code
  indexes vcard.address.locality
  indexes vcard.address.extended_address
  indexes vcard.address.post_office_box

  indexes billing_vcard.full_name, :as => :billing_full_name
  indexes billing_vcard.nickname, :as => :billing_nickname
  indexes billing_vcard.family_name, :as => :billing_family_name
  indexes billing_vcard.given_name, :as => :billing_given_name
  indexes billing_vcard.additional_name, :as => :billing_additional_name
  indexes billing_vcard.address.street_address, :as => :billing_street_address
  indexes billing_vcard.address.postal_code, :as => :billing_postal_code
  indexes billing_vcard.address.locality, :as => :billing_locality
  indexes billing_vcard.address.extended_address, :as => :billing_extended_address
  indexes billing_vcard.address.post_office_box, :as => :billing_post_office_box

  indexes doctor_patient_nr

  indexes cases.praxistar_eingangsnr
end
