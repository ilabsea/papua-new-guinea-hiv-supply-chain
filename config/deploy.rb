# sudo groupadd deployers
# sudo usermod -a -G deployers ilab
# sudo chown -R ilab:deployers /var/www
# sudo chmod -R g+w /var/www

require "capistrano-rbenv"
set :rbenv_ruby_version, "2.0.0-p247"

# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

set :stages, %w(production staging)
set :default_stage, :production
require 'capistrano/ext/multistage'



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
    # run "ln -nfs #{shared_path}/data #{release_path}/"
  end
end


before "deploy:start", "deploy:migrate"
before "deploy:restart", "deploy:migrate"

#after "deploy:update_code", "deploy:symlink_data"


