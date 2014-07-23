load 'deploy/assets'
require "bundler/capistrano"
require "dotenv/capistrano"
#require 'capistrano/local_precompile'

set :application, "feedex"
set :repository,  "git@github.com:Getting-Real/feedex-backend.git"

set :deploy_to, "/webapps/feedex"
set :branch, :develop
set :user, 'deployer'
set :use_sudo, false
set :asset_env, "RAILS_GROUPS=assets"
set :assets_role, :app

set :rvm_type, :system

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "54.255.170.227"                          # Your HTTP server, Apache/etc
role :app, "54.255.170.227"                          # This may be the same as your `Web` server
role :db,  "54.255.170.227", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

before 'deploy:db:symlink_db', 'deploy:setup_config'
before 'deploy:assets:precompile', 'deploy:db:symlink_db'
after "deploy", "deploy:migrate"
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:update_code', 'deploy:setup_config'
after 'deploy:update_code', 'deploy:db:symlink_db'
after 'deploy:update_code', 'deploy:assets:precompile'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
def remote_file_exists?(full_path)
    'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :setup_config do
    run "mkdir -p #{deploy_to}/shared/config"
    run "mkdir -p #{deploy_to}/shared/log"
#    run "chmod -Rf 0666 #{deploy_to}/shared/log/"
    if remote_file_exists?("#{deploy_to}/shared/config/database.yml")
      puts "database.yml exists, continuing on ..."
    else
      run "cd #{current_release}; cp -u #{current_release}/config/database.yml.example #{deploy_to}/shared/config/database.yml"
    end
  end
  task :symlink_shared do
    run "ln -nfs #{deploy_to}/shared/assets #{current_release}/public/assets"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  namespace :db do

    task :seed do
      run "cd #{current_release}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
    end

    desc "Symlinks the database.yml"
    task :symlink_db, :roles => :app do
      run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    end

    task :reset, :roles => [:web, :db] do
      run "cd #{current_release}; bundle exec rake db:drop RAILS_ENV=#{rails_env}"
      run "cd #{current_release}; bundle exec rake db:create RAILS_ENV=#{rails_env}"
      run "cd #{current_release}; bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
    end
  end

namespace :assets do
  task :precompile, :roles => :web, :except => { :no_release => true } do
    begin
      from = source.next_revision(current_revision)
    rescue
      err_no = true
    end
    if err_no || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
      puts "running the assets"
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} RAILS_GROUPS=assets asset:clean assets:precompile}
    else
      logger.info "Skipping asset pre-compilation because there were no asset changes"
    end
  end
end
end
def run_interactively(command, server=nil)
    server ||= find_servers_for_task(current_task).first
    exec %Q(ssh #{server.host} -l #{user} -t 'source /etc/profile && cd #{current_path} && #{command}')
end

namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    puts "You're about to enter PRODUCTION level console..."
    puts "Please exercise caution ..."
    run_interactively "bundle exec rails console #{rails_env}"
  end

  desc "tail production log files"
  task :tail_logs, :roles => :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
  desc "tail printer logs"
  task :tail_printer_logs, :roles => :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -f #{shared_path}/log/printer.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
  desc "tail job logs"
  task :tail_job_logs, :roles => :app do
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -f #{shared_path}/log/job.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
end

require "rvm/capistrano"
