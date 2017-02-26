
module TwitterClient
  class TwitterApi
    attr_reader :client
    
    def initialize(config = {})
      @client = Twitter::REST::Client.new do |t|
        t.consumer_key        = config['consumer_key']
        t.consumer_secret     = config['consumer_secret']
        t.access_token        = config['access_token']
        t.access_token_secret = config['token_secret']
      end
    end

    def friendship_graph(graph, origin)
      origin_id = '0'
      begin
        @client.friend_ids(origin).each do |id|
          graph.add_vertex(id.to_s, {group: 1})
          graph.add_edge(origin_id, id.to_s, {value: 0})
        end
        
      rescue Twitter::Error::TooManyRequests => error
        # TODO: backoff strategy
      ensure
        graph.add_vertex(origin_id, {name: origin, value: 0})
        return graph
      end
    end



    # quick to run out rate-limit 
    def friends_friendships(graph, origin_id)
      graph.vertices.keys - [origin_id].combination(2).each do |a,b|
        begin
          friendship = @client.friendship(a,b)
          graph.add_vertex(a, {name: friendship.target.screen_name})
          graph.add_vertex(b, {name: friendship.source.screen_name})
          if friendship.source.following? or friendship.source.followed_by
            graph.add_edge(a.to_s, b.to_s, {value: 1})
          end
        rescue Twitter::Error::TooManyRequests => error
          # TODO: backoff strategy
          break
        end
      end

      graph
    end
    
  end
end
