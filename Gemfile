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
gem 'cancan', '1.6.7'
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
gem 'premailer', :git => "git://github.com/alexdunae/premailer.git", :ref => '023af276c8106294980eb9007e7ca4901fd568fd'
gem "premailer-rails3", :git => "git://github.com/tdgs/premailer-rails3.git"
#gem 'actionmailer-instyle', :require => 'action_mailer/in_style', :path => '../actionmailer-instyle'

# Search
gem 'thinking-sphinx', '~> 2.1' # Incompatible API

gem 'jcrop-rails'

# Barcode
gem 'barby'

# Printing
gem 'cupsffi'

# Postalcode
gem 'fastercsv'

# Rails 3 Migration
gem 'dynamic_form'

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
  gem 'rspec-rails', '~> 2.12'
  gem 'rspec-activemodel-mocks'

  # Browser
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'selenium-webdriver'

  # Matchers/Helpers
  gem 'accept_values_for', '~> 0.4.3'

  # Debugger
  gem 'pry-rails'
  gem 'pry-byebug'

  # Fixtures
  gem 'connection_pool'
  gem "factory_girl_rails"
end

# Docs
# ====
group :doc do
  # Docs
  gem 'rdoc'
end
