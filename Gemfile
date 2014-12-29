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
  gem 'accept_values_for'

  # Browser
  gem 'capybara'

  # Spork
  gem 'spork-rails'
end

group :test, :development do
  # Framework
  gem 'rspec-rails'

  # Fixtures
  gem "factory_girl_rails", :require => false # To make Spork happy
end

group :tools do
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'rb-inotify'
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
gem 'nokogiri'
gem 'premailer', :git => "git://github.com/alexdunae/premailer.git"
gem "premailer-rails3", :git => "git://github.com/tdgs/premailer-rails3.git"
#gem 'actionmailer-instyle', :require => 'action_mailer/in_style', :path => '../actionmailer-instyle'

# Search
gem 'thinking-sphinx', '~> 2.1'

gem 'jcrop-rails'

# Barcode
gem 'barby'

# Printing
gem 'cupsffi', :git => 'git://github.com/huerlisi/cupsffi.git'

# Postalcode
gem 'fastercsv'

# Rails 3 Migration
gem 'dynamic_form'
