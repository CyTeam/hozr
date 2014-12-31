require 'rails_helper'

feature 'overall functionality' do
  let!(:user_admin) { FactoryGirl.create :user_admin }

  scenario 'Basic usage', js: true do
    # Login
    visit root_path

    fill_in 'Benutzername', with: user_admin.login
    fill_in 'Passwort', with: user_admin.password
    click_button 'Anmelden'

    expect(page).to have_text('Auftragsformulare')

    # Create a doctor
    navigate_to 'Suche/Ärzte'

    click_link 'Erfassen'
    fill_in 'doctor_vcard_attributes_family_name', with: 'Muster'
    fill_in 'doctor_vcard_attributes_given_name', with: 'Peter'

    click_button 'Arzt erstellen'

    # Check doctors list
    navigate_to 'Suche/Ärzte'

    expect(page).to have_text('Muster Peter')

    # Create a patient
    navigate_to 'Suche/Patienten'

    click_link 'Erfassen'
    fill_in 'patient_vcard_attributes_family_name', with: 'Meier'
    fill_in 'patient_vcard_attributes_given_name', with: 'Angela'
    fill_in 'Geburtsdatum', with: '21.5.1983'
    choose 'F'
    fill_in 'Strasse', with: 'Gartenweg 7'
    fill_in 'patient_vcard_attributes_address_attributes_zip_locality', with: '6318 Walchwil'

    click_button 'Patient erstellen'

    # Search for the patient
    fill_in 'query', with: 'Ang'
    page.execute_script("$('input[name=query]').closest('form').submit()")

    expect(page).to have_text('1 Treffer')
    expect(page).to have_text('MEIER')
    expect(page).to have_text('Angela')
  end
end
