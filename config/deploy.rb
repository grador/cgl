require 'rvm/capistrano'
require 'bundler/capistrano'
set :ssh_options, {:forward_agent => true}
set :rvm_type, :system
# set :rvm_ruby_string, "1.9.3-p392@repo_name"
set :application, "Cgl"
set :repository, "https://github.com/grador/cgl/"
set :default_stage, "production"
# set :stages, %w(production)
set :use_sudo, false
set :user, "root" # нужно предварительно создать юзера на сервере, юзать root"a не стоит
# set :group, "deployers"
set :scm, :git
set :normalize_asset_timestamps, false

set :rails_env, "production"
set :branch, "master"
set :deploy_to, "/var/www/callgoodluckcom"
set :deploy_via, :copy
set :keep_releases, 3
default_run_options[:pty] = true
server "31.131.20.142", :web, :app, :db, :primary => true

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

desc "Symlink shared config files"
task :symlink_config_files do
    run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
end
desc "Restart Passenger app"
task :restart do
    run "#{ try_sudo } touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
end

# if you"re still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,"tmp","restart.txt")}"
  end
  after "deploy", "deploy:symlink_config_files"
  after "deploy", "deploy:restart"
# if you want to clean up old releases on each deploy uncomment this:
  after "deploy", "deploy:cleanup"
end
