server_address = 'staging.png.com'
set :user, 'ilab'
set :server, server_address
set :branch, 'develop'
server server_address, :app, :web, :db, primary: true
