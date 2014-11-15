set :application, "feedex"
set :rails_env, "production"
set :branch, "production"
set :location1, "ec2-54-201-48-117.us-west-2.compute.amazonaws.com"
set :deploy_to, "/home/ubuntu/feedex"

role :web, location1
role :app, location1
role :db, location1, :primary => true
