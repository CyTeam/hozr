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
    click_link 'Suche'
    click_link 'Ärzte'

    click_link 'Erfassen'
    fill_in 'doctor_vcard_attributes_family_name', with: 'Muster'
    fill_in 'doctor_vcard_attributes_given_name', with: 'Peter'

    click_button 'Arzt erstellen'

    # Check doctors list
    click_link 'Suche'
    click_link 'Ärzte'

    expect(page).to have_text('Muster Peter')
  end
end
