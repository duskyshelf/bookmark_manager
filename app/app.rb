require 'sinatra/base'
require 'sinatra/flash'

class BManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  use Rack::MethodOverride

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    params[:tag].split.each do |input|
      link.tags << Tag.create(name: input)
    end
    link.save
    redirect '/links'
  end

  get '/links/new' do
    erb :'links/new_links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new_user'
  end

  post '/users' do
    @user = User.create(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect '/links'
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new_user'
    end
  end

  def current_user
    @current_user ||= User.get(session[:user_id])
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect '/links'
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    flash[:notice] = 'goodbye!'
    redirect '/links'
  end

  get '/password_reset' do
    erb :password_reset
  end

  post '/password_reset' do
    user = User.first(email: params[:email])
    user.password_token = 'token'
    user.save
    "Check your emails"
  end

  get '/users/password_reset/:password_token' do
    session[:token] = params[:password_token]
    erb :new_password
  end

  post '/new_password' do
    user = User.first(password_token: session[:token])
    user.password = params[:new_password]
    user.password_confirmation = params[:new_password]
    user.save
    redirect '/links'
  end



  run! if app_file == $0
end
