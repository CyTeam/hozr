namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} start"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} restart"
  end
end

namespace :bluepill do
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} status"
  end
end
