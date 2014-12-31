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

  indexes billing_vcard.full_name
  indexes billing_vcard.nickname
  indexes billing_vcard.family_name
  indexes billing_vcard.given_name
  indexes billing_vcard.additional_name
  indexes billing_vcard.address.street_address
  indexes billing_vcard.address.postal_code
  indexes billing_vcard.address.locality
  indexes billing_vcard.address.extended_address
  indexes billing_vcard.address.post_office_box

  indexes doctor_patient_nr

  indexes cases.praxistar_eingangsnr
end
