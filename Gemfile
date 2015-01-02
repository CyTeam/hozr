# Gemfile
# =======
# Policies:
# * We do not add versioned dependencies unless needed
# * If we add versioned dependencies, we document the reason
# * We use single quotes
# * We use titles to group related gems

# Settings
# ========
source 'http://rubygems.org'

# Rails
# =====
gem 'rails', '~> 3.2'

# Unicorn
# =======
gem 'unicorn'

# Database
# ========
gem 'mysql2'

# Asset Pipeline
# ==============
gem 'less-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer'

# CRUD
# ====
gem 'inherited_resources'
gem 'has_scope'
gem 'kaminari'

# UI
# ==
gem 'jquery-rails'
gem 'haml'
gem 'simple_form'
gem 'twitter-bootstrap-rails'
gem 'select2-rails'
gem 'lyb_sidebar'
gem 'simple-navigation'

# I18n
# ====
gem 'i18n_rails_helpers'

# Access Control
# ==============
gem 'devise', '~> 2.2' # Changed API
gem 'cancan'
gem 'lyb_devise_admin'

# Validations
gem 'validates_timeliness'

# Application Settings
gem 'ledermann-rails-settings', '~> 1.2', :require => 'rails-settings' # Changed API

# Addresses
gem 'unicode_utils'
gem 'has_vcards', '~> 0.20'
gem 'autocompletion'
gem 'swissmatch'
gem 'swissmatch-location', :require => 'swissmatch/location/autoload'

# Uploads
gem 'carrierwave'

# Wysiwyg
gem 'tinymce-rails'

# Files
gem 'file-column', :git => 'https://github.com/huerlisi/file_column.git'
gem 'rmagick'

# Multiple Databases
gem 'use_db'

# PDF generation with PRAWN
gem 'prawn'
gem 'prawnto'

# Mail
gem 'nokogiri'
gem 'premailer'
gem "premailer-rails"
#gem 'actionmailer-instyle', :require => 'action_mailer/in_style', :path => '../actionmailer-instyle'

# Search
gem 'thinking-sphinx'

gem 'jcrop-rails'

# Barcode
gem 'barby'

# Printing
gem 'cupsffi', require: !ENV['CI']

group :development do
  # Debugging
  gem 'better_errors'
  gem 'binding_of_caller'  # Needed by binding_of_caller to enable html console

  # Deployment
  gem 'capones_recipes'
end

# Dev and Test
# ============
group :development, :test do
  # Testing Framework
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'

  # Browser
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'selenium-webdriver'

  # Matchers/Helpers
  gem 'accept_values_for'

  # Debugger
  gem 'pry-rails'
  gem 'pry-byebug'

  # Fixtures
  gem 'database_cleaner'
  gem 'connection_pool'
  gem "factory_girl_rails"
end

# Docs
# ====
group :doc do
  # Docs
  gem 'rdoc'
end
