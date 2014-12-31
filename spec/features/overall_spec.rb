require 'rails_helper'

feature 'overall functionality' do
  let!(:user_admin) { FactoryGirl.create :user_admin }

  scenario 'I can see the login page', js: true do
    # Login
    visit root_path

    fill_in "Benutzername", :with => user_admin.login
    fill_in "Passwort", :with => user_admin.password
    click_button "Anmelden"

    expect(page).to have_text('Auftragsformulare')
  end
end
