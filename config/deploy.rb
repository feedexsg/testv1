require "rvm/capistrano"
require 'capistrano/ext/multistage' 

set :stages, ["staging", "production"]
set :default_stage, "staging"
set :keep_releases, 3
set :repository, "git@bitbucket.org:getting-real/feedex-backend.git"

default_run_options[:pty] = true
set :scm, :git
ssh_options[:forward_agent] = true

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :user, 'ubuntu'
set :use_sudo, false
set :deploy_to, "/home/ubuntu/feedex"
set :default_shell, "/bin/bash -l"

set :test_log, "log/capistrano.test.log"

namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{ current_path }/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    task t, :roles => :app do ; end
  end

  desc "Deploy with migrations"
   task :long do
     transaction do
       update_code
       web.disable
       create_symlink
       migrate
     end

     restart
     web.enable
     cleanup
   end

  task :custom_symlink, :roles => :app do
    # run "ln -s #{ shared_path }/robots.txt #{ current_path }/public/robots.txt"
    run "ln -s #{ shared_path }/database.yml #{ current_path }/config/database.yml"
  end

  task :delayed_job, :roles => :app do
    #run "RAILS_ENV=production #{current_path}/bin/delayed_job start"
  end

  after "deploy:create_symlink", "deploy:custom_symlink"
  after "deploy:create_symlink", "deploy:delayed_job"
  after "deploy:update", "deploy:cleanup"
  
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(release_path, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --path '#{shared_path}/bundle' --deployment --quiet --without development test"

    on_rollback do
      if previous_release
        run "cd #{release_path} && bundle install --path '#{shared_path}/bundle' --deployment --quiet --without development test"
      else
        logger.important "no previous release to rollback to, rollback of bundler:install skipped"
      end
    end
  end

  task :bundle_new_release, :roles => :db do
    bundler.create_symlink
    bundler.install
  end
end

after "deploy:rollback:revision", "bundler:install"
after "deploy:update_code", "bundler:bundle_new_release"
