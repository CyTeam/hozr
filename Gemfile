# Settings
# ========
source 'http://rubygems.org'

# Rails
# =====
gem 'rails'

# Unicorn
# =======
gem 'unicorn'

# Database
gem 'mysql2'
gem 'activerecord-sqlserver-adapter'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'therubyracer'
  gem 'uglifier'
end

gem 'jquery-rails'

# Development
# ===========
group :development do

  # Capistrano
  gem 'capones_recipes'
end

# Test
# ====
group :test do
  # Matchers/Helpers
  gem 'shoulda'

  # Mocking
  # gem 'mocha'

  # Browser
  gem 'capybara'

  # Autotest
  gem 'autotest'
  gem 'autotest-rails'
  gem 'ZenTest', '< 4.6.0' # Keep it working with gems < 1.8
end

group :test, :development do
  # Framework
  # gem "rspec"
  # gem 'rspec-rails'

  # Fixtures
  # gem "factory_girl_rails", "~> 1.1.rc1"
  # gem "factory_girl", "~> 2.0.0.rc1"

  # Integration
  # gem 'cucumber-rails'
  # gem 'cucumber'
end

group :development do
  # RDoc
  gem 'rdoc'
end

# Standard helpers
# ================
# CRUD
gem 'kaminari'

# Application
# ===========
# Authentication
gem 'devise'
gem 'cancan'
gem 'lyb_devise_admin'

# Helpers
gem 'inherited_resources'
gem 'has_scope'
gem 'i18n_rails_helpers'
gem 'haml'
gem 'sass-rails'

# Layout
gem 'lyb_sidebar'

# Bootstrap
gem 'less-rails'
gem 'twitter-bootstrap-rails'
gem 'simple_form'
gem 'select2-rails'
gem 'simple-navigation'

# Validations
gem 'validates_timeliness'

# Application Settings
gem 'ledermann-rails-settings', :require => 'rails-settings'

# Addresses
gem 'unicode_utils'
gem 'has_vcards'
gem 'autocompletion'
gem 'swissmatch', :git => 'https://github.com/apeiros/swissmatch.git'
gem 'swissmatch-location', :git => 'https://github.com/apeiros/swissmatch-location.git'
gem 'swissmatch-directories', :git => 'https://github.com/huerlisi/swissmatch-directories.git'
gem 'swissmatch-rails', :git => 'https://github.com/apeiros/swissmatch-rails.git'

# Uploads
gem 'carrierwave'

# Autocomplete
gem 'rails3-jquery-autocomplete', :git => 'https://github.com/slash4/rails3-jquery-autocomplete.git'

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
gem 'premailer', :git => "git://github.com/alexdunae/premailer.git"
gem "premailer-rails3", :git => "git://github.com/tdgs/premailer-rails3.git"
#gem 'actionmailer-instyle', :require => 'action_mailer/in_style', :path => '../actionmailer-instyle'

# Search
gem 'thinking-sphinx'

gem 'jcrop-rails'

# Barcode
gem 'barby'

# Printing
gem 'cupsffi', :git => 'git://github.com/huerlisi/cupsffi.git'

# Postalcode
gem 'fastercsv'

# Rails 3 Migration
gem 'prototype_legacy_helper', '0.0.0', :git => 'git://github.com/rails/prototype_legacy_helper.git'
gem 'dynamic_form'
