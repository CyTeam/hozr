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
end

group :test, :development do
  # Framework
  gem 'rspec-rails'

  # Fixtures
  gem "factory_girl_rails"
end

group :development do
  # RDoc
  gem 'rdoc'
end

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
gem 'devise'
gem 'cancan'
gem 'lyb_devise_admin'

# Validations
gem 'validates_timeliness'

# Application Settings
gem 'ledermann-rails-settings', :require => 'rails-settings'

# Addresses
gem 'unicode_utils'
gem 'has_vcards'
gem 'autocompletion'
gem 'swissmatch'

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
gem 'cupsffi'

# Postalcode
gem 'fastercsv'

# Rails 3 Migration
gem 'dynamic_form'
