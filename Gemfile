# Settings
# ========
source 'http://rubygems.org'

# Rails
# =====
gem 'rails'

# Database
gem 'sqlite3'
gem 'mysql2'
gem 'activerecord-sqlserver-adapter'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'sprockets'
  gem 'coffee-rails'
  gem 'therubyracer'
  gem 'uglifier'
end

gem 'jquery-rails'

# Development
# ===========
group :development do
  # Haml generators
  gem 'hpricot'
  gem 'ruby_parser'

  # Capistrano
  # gem 'capistrano'
  # gem 'capistrano-ext'
  # gem 'cap-recipes'
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
gem 'will_paginate', '~> 3.0.pre'

# Application
# ===========
# Authentication
gem 'devise'
gem 'cancan'
gem 'lyb_devise_admin', :git => 'https://github.com/huerlisi/lyb_devise_admin.git'

# Helpers
gem 'inherited_resources'
gem 'i18n_rails_helpers'
gem 'haml'

# Formtastic
gem 'formtastic'

# Wysiwyg
gem 'tinymce-rails'

# Files
gem 'file-column', :path => '/root/src/file_column'

# Multiple Databases
gem 'use_db'

# PDF generation with PRAWN
gem 'prawn'
gem 'prawnto'

# Search
gem 'thinking-sphinx', :git => 'https://github.com/freelancing-god/thinking-sphinx.git'

# Barcode
gem 'barby'

# Printing
gem 'cups'

# Postalcode
gem 'fastercsv'

# Rails 3 Migration
gem 'prototype_legacy_helper', '0.0.0', :git => 'git://github.com/rails/prototype_legacy_helper.git'
gem 'dynamic_form'
