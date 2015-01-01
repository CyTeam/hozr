module NavigationHelpers
  # Navigation helper
  #
  # Expects a string like 'Search/Doctors' and then navigates
  # to the 'Doctors' link of the 'Search' menu.
  def navigate_to(context)
    steps = context.split('/')
    steps.each do |step|
      click_link step
    end
  end
end

RSpec.configure do |config|
  config.include NavigationHelpers, type: :feature
end
