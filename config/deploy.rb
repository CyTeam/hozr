# encoding: UTF-8

# Application
set :application, 'hozr'
set :repository,  'git@github.com:CyTeam/hozr.git'

require 'capones_recipes/cookbook/rails'
require 'capones_recipes/tasks/database/setup'
require 'capones_recipes/tasks/thinking_sphinx'
require 'capones_recipes/tasks/carrier_wave'
require 'capones_recipes/tasks/sync'
require 'capones_recipes/tasks/bluepill'

load 'deploy/assets'

# Staging
set :default_stage, 'staging'

# Deployment
set :user, "deployer"                               # The server's user for deploys

# Shared directories
set :shared_children, shared_children + ['tmp/sockets', 'public/trigger', 'public/order_form']

# Sync directories
set :sync_directories, ['uploads', 'system']
set :sync_backups, 3

# Configuration
set :scm, :git
#ssh_options[:forward_agent] = true
set :use_sudo, false
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :copy_exclude, [".git", "spec"]

# Dependencies
depend :remote, :gem, 'bundler', '> 0'
depend :remote, :gem, 'bluepill', ''

# Headers for gem compilation
depend :remote, :deb, "build-essential", ''
depend :remote, :deb, "ruby1.9.1-dev", ''
depend :remote, :deb, "libcups2-dev", ''
depend :remote, :deb, "libmysqlclient-dev", ''
depend :remote, :deb, "libsqlite3-dev", ''
depend :remote, :deb, "libxml2-dev", ''
depend :remote, :deb, "libxslt1-dev", ''
depend :remote, :deb, "libmagickcore-dev", ''
depend :remote, :deb, "libmagickwand-dev", ''
depend :remote, :deb, "sphinxsearch", ''
depend :remote, :deb, "gocr", ''
depend :remote, :deb, "sane-utils", ''
depend :remote, :deb, "imagemagick", ''
