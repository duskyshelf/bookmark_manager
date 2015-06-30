require 'sinatra/base'

class BManager < Sinatra::Base

  set :views, proc { File.join(root, '..', 'view') }

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    Link.create(url: params[:url], title: params[:title])
    redirect '/links'
  end

  get '/links/new' do
    erb :'links/new_links'
  end




  run! if app_file == $0
end
