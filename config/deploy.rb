# sudo groupadd deployers
# sudo usermod -a -G deployers ilab
# sudo chown -R ilab:deployers /var/www
# sudo chmod -R g+w /var/www
# sudo chmod go-w -R /var/www warning “Insecure world writable dir /home/chance ” in PATH, mode 040777 http://stackoverflow.com/questions/5380671/getting-the-warning-insecure-world-writable-dir-home-chance-in-path-mode-04
# ssh config for remote server and repo
require 'whenever'
require "capistrano-rbenv"
set :rbenv_ruby_version, "2.0.0-p247"

set :stages, %w(production staging)
set :default_stage, :production
require 'capistrano/ext/multistage'

require 'bundler/capistrano'
require 'assets/deploy'

#set :whenever_command, "bundle exec whenever" # for bundler
#set :whenever_environment, defer { stage } # multistaging
#require "whenever/capistrano"

set :application, "png"
set :use_sudo , false

set :repository, "git@bitbucket.org:channainfo/papua-new-guinea-hiv-aids.git"
set :scm, :git
set :scm_username, 'channainfo'

set :deploy_to, '/var/www'
set :deploy_via, :remote_cache

default_environment['TERM'] = ENV['TERM']


namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_data, :roles => :app do
  	p "symlink_data"
    run "ln -nfs #{shared_path}/data #{release_path}/public/data"
  end

  task :whenever do
  	run "cd #{release_path} && RAILS_ENV=production bundle exec whenever --update-crontab png-health-system "
  end

  task :symlink_config, roles: :app do
  	p 'symlink_config'

    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/nuntium.yml  #{release_path}/config/nuntium.yml"
  end
end

namespace :db do
  task :create do
    run "cd #{release_path} && bundle exec rake db:create RAILS_ENV=production"
  end

  task :seed do
  	run "cd #{release_path} && bundle exec rake db:seed RAILS_ENV=production"
  end

  task :default_data do
  	run "cd #{release_path} && bundle exec rake png:load_default_data RAILS_ENV=production"
  end
end


namespace :assets do
  task :precompile do
  	run "cd #{release_path} && bundle exec rake assets:precompile RAILS_ENV=production"
  end
end


# deploy:finalize_update
after "deploy:update_code", "deploy:symlink_config"
after "deploy:update_code", "deploy:symlink_data"
after 'deploy:update_code', 'deploy:whenever'
#after 'deploy:update_code', 'assets:precompile'

before "deploy:start", "deploy:migrate"
before "deploy:restart", "deploy:migrate"


