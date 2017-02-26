module TwitterClient

  class App < Sinatra::Base
    register Sinatra::ConfigFile

    configure :development do
      register Sinatra::Reloader
    end
    set :app_file, __FILE__
    set :root, File.expand_path('../../../', __FILE__)
    set :public_folder, root + '/public'
    config_file root + '/config.yml'

    set :twitter_client, TwitterApi.new(settings.twitter)
    set :gcache, Cache.new()
    
    get '/' do
      erb :index
    end
    
    get '/graph' do
      screen_name = params[:screen_name].delete(' ')
      return json({}, :encoder => :to_json) if screen_name.size < 1
      graph = settings.gcache.cached(screen_name) do
        new_graph = Graph.new
        settings.twitter_client.friendship_graph(new_graph, screen_name)
      end
      if graph
        return json(graph.to_hash, :encoder => :to_json)
      end
      status 509
    end
  end
end
