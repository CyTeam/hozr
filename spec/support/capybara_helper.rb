require 'capybara/rails'
require 'capybara/poltergeist'

# Capybara driver configuration
Capybara.register_driver :chrome do |app|
  Selenium::WebDriver::Chrome.path = ENV['CHROME_PATH'] if ENV['CHROME_PATH']
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :firefox do |app|
  Selenium::WebDriver::Firefox.path = ENV['FIREFOX_PATH'] if ENV['FIREFOX_PATH']
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, window_size: [ 1600, 1200 ])
end

Capybara.configure do |config|
  config.default_driver = (ENV['DRIVER'] || :rack_test).to_sym

  config.javascript_driver = (ENV['JS_DRIVER'] || :poltergeist).to_sym
  config.javascript_driver = :poltergeist if config.javascript_driver == :phantomjs

  config.match = :prefer_exact
end
