require "sinatra/activerecord"
require "sinatra"

enable :sessions

# Local
#ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "./database.sqlite3")
#set :database, {adapter: "sqlite3", database: "./database.sqlite3"}

# Heroku
#ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end

class User < ActiveRecord::Base
end

get '/' do
  erb :home
end

# get '/signup' do
#   @user = User.new
#   erb :'users/signup'
# end


get '/profile' do
  erb :profile
end

post '/signup' do
  @user = User.new(params)
  if @user.save
    p "#{@user.first_name} was saved to the database."
    redirect '/thankyou'
  end
  erb :thankyou
end

get '/thankyou' do
  erb :thankyou
end

get '/stories' do
  erb :stories
end

post '/stories' do
  redirect "/stories"
end

get '/login' do
  if session[:user_id]
    redirect '/stories'
  else
  erb :home
  end
end

post '/login' do
  given_password = params['password']
  user = User.find_by(email: params['email'])
  if user
    if user.password == given_password
      p 'User authenticated successfully!'
      session[:user_id] = user.id
    else
      p "Invalid email or password"
    end
  end
  redirect '/'
end

# delete request
post '/logout' do
  session.clear
  p 'User logged out successfully'
  redirect '/'
end
