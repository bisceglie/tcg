module TwitterClient
  class Graph
    def initialize()
      @adj_list, @edge_set = {}, Set.new
    end
    
    def vertices()
      @adj_list.keys
    end
    
    def edges()
      @edge_set.to_a
    end
    
    def add_vertex(id, opts={})
      add_or_set_vertex(id, opts)
    end


    def add_edge(source, target, opts={})
      add_keys_if_needed(source, target)
      
      @edge_set.add({
                   source: source,
                   target: target,
                   value: opts[:value]
                    })
      self
    end

    def to_hash()
      {
        vertices: vertices.map { |id|
          {id: id, value: @adj_list[id][:value]}
        },
        edges: edges()
      }
    end
    
    def to_json()
      to_hash.to_json
    end

    private
    def add_keys_if_needed(*keys)
      keys.each do |key|
        unless @adj_list.key?(key)
          add_or_set_vertex(key)
        end
      end
    end
    def add_or_set_vertex(id, opts={})
      @adj_list[id] = {
        name: opts[:name],
        group: opts[:group]
      }
      self
    end
  end
end
