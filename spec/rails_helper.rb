# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] = 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

I18n.locale = 'de-CH'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Load all shared examples
Dir[Rails.root.join('spec/*/shared_examples/**/*.rb')].each { |f| require f }

# Speed up test runs
Devise.stretches = 1

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Include factory girl dsl
  config.include FactoryGirl::Syntax::Methods

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Render views in controller specs
  config.render_views

  # Include devise test helpers.
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :helper

  # Run each example in a transaction
  config.use_transactional_fixtures = true
end

module ActiveRecord
  # Share the same connection across all threads, using the connection_pool gem
  # to ensure thread safety.
  #
  # See http://www.spacevatican.org/2012/8/18/threading-the-rat/ as well as
  # https://gist.github.com/mperham/3049152 for details. The proposed solution
  # didn't work though, only after simplifying it to use the mattr_accessor directly
  # and assigning the shared connection dynamically on creation.
  class Base
    mattr_accessor :shared_connection

    def self.connection
      if ENV['mutant']
        super
      else
        self.shared_connection ||= ConnectionPool::Wrapper.new(size: 1) { retrieve_connection }
      end
    end
  end
end
