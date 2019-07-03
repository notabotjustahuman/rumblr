require "sinatra/activerecord"
require "sinatra"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "./database.sqlite3")

enabled :sessions

class User < ActiveRecord::Base
end

get '/' do
  erb :home
end

get './signup' do
  @user = User.new
  erb: 'users/signup'
end
