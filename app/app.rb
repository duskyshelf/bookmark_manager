require 'sinatra/base'

class BManager < Sinatra::Base

  set :views, proc { File.join(root, '..', 'view') }

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

  post '/users/welcome' do
    User.create(email: params[:email],
                password: params[:password])
    "Welcome, #{params[:email]}"
  end

  run! if app_file == $0
end
