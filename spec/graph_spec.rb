require File.expand_path '../spec_helper.rb', __FILE__

describe TwitterClient::Graph do
  empty_graph_hash = {vertices: [], edges: []}
  vertex_ids = [:foo, :bar, :baz]

  connected_graph_hash = {:vertices=>[{:id=>:foo, :value=>nil}, {:id=>:bar, :value=>nil}, {:id=>:baz, :value=>nil}], :edges=>[{:source=>:foo, :target=>:bar, :value=>nil}, {:source=>:foo, :target=>:baz, :value=>nil}, {:source=>:bar, :target=>:baz, :value=>nil}]}
  let!(:vertex_combinations) {
    vertex_ids.combination(2)
  }

  let(:new_graph) {
    TwitterClient::Graph.new
  }
  let(:sparse_graph) {
    g = new_graph
    vertex_ids.collect { |id| g.add_vertex(id) }
    g
  }
  let(:connected_graph) {
    g = sparse_graph
    vertex_combinations.collect { |a,b| g.add_edge(a,b) }
    g
  }

  describe 'creating new graphs' do
    it 'should an empty list of vertices' do
      expect(new_graph.vertices).to eq([])
    end
    it 'should have an empty list of edges' do
      expect(new_graph.edges).to eq([])
    end
    it 'should expose a to_hash method' do
      expect(new_graph.to_hash).to eq(empty_graph_hash)
    end
    it 'should expose a to_json method' do
      expect(new_graph.to_json).to eq(empty_graph_hash.to_json)
    end
  end

  describe 'updating graphs' do
    describe 'adding vertices' do
      it 'should allow vertices to be added' do
        expect(sparse_graph.vertices).to eq(vertex_ids)
      end
      it 'should allow edges to be added' do
        expect(connected_graph.edges.size).to eq(vertex_combinations.size)
      end
      it 'should update vertices when adding an edge with a new vertex' do
        g = sparse_graph
        expect(g.vertices.size).to eq(vertex_ids.size)
        expect(g.edges).to eq([])
        g.add_edge(:snickers, :pickles)
        expect(g.edges.size).to eq(1)
        expect(g.vertices.size).to eq(vertex_ids.size + 2)
      end
      it 'should ignore duplicate vertices' do
        g = sparse_graph
        num_vertices = g.vertices.size
        expect(g.add_vertex(vertex_ids[0]).vertices.size).to eq(num_vertices)
      end
      it 'should ignore duplicate edges' do
        g = connected_graph
        num_edges = g.edges.size
        expect(g.add_edge(vertex_ids[0], vertex_ids[1]).edges.size).to eq(num_edges)
      end
      it 'should treat edges as directed' do
        g = connected_graph
        num_edges = g.edges.size
        expect(vertex_combinations.include?([vertex_ids[1], vertex_ids[0]])).to be(false)
        expect(g.add_edge(vertex_ids[1], vertex_ids[0]).edges.size).to eq(num_edges + 1)
      end
      it 'render well formed json' do
        expect(connected_graph.to_json).to eq(connected_graph_hash.to_json)
      end
    end
  end
end
