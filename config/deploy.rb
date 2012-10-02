# Application
set :application, 'hozr'
set :repository,  'git@github.com:huerlisi/hozr.git'

require 'capones_recipes/cookbook/rails'
require 'capones_recipes/tasks/database/setup'
require 'capones_recipes/tasks/thinking_sphinx'
require 'capones_recipes/tasks/sync'
require 'capistrano-unicorn'

load 'deploy/assets'

# Staging
set :default_stage, 'staging'

# Deployment
set :user, "www-data"                               # The server's user for deploys

# Shared directories
set :shared_children, shared_children + ['tmp/sockets', 'config/swissmatch.yml']

# Configuration
set :scm, :git
#ssh_options[:forward_agent] = true
set :use_sudo, false
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :copy_exclude, [".git", "spec"]
