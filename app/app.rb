require 'sinatra/base'

class BManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'

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
    erb :'links/new_user'
  end

  post '/users' do
    user = User.create(email: params[:email],
                password: params[:password])
    session[:user_id] = user.id
    redirect '/'
  end

  def current_user
    @user ||= User.get(session[:user_id])
  end

  run! if app_file == $0
end
