server_address = 'png.com'
set :user, 'ilab'
set :server, server_address
set :branch, :master
server server_address, :app, :web, :db, primary: true
