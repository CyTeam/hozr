require 'rails_helper'

feature 'overall functionality' do
  scenario 'I can see the login page', js: true do
    visit root_path
  end
end
