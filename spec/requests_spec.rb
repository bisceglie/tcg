require File.expand_path '../spec_helper.rb', __FILE__

describe 'The index page' do
  it 'should allow accessing the index page' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Twitter screen name')
  end
end

describe 'The graph page' do
  describe 'when system cannot generate more graphs' do
    before :each do
      allow_any_instance_of(TwitterClient::Cache).to receive(:cached).and_return(nil)
    end
    it 'should return an error' do
      get '/graph', { screen_name: 'foo' }
      expect(last_response.status).to eq(509)
    end
  end
  describe 'when graphs can be generated' do
    graph_instance = TwitterClient::Graph.new()
    before :each do
      allow_any_instance_of(TwitterClient::Cache).to receive(:cached).and_return(graph_instance)
    end
    it 'should return a graph as json' do
      get '/graph', { screen_name: 'bar' }
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to eq(graph_instance.to_json)
    end
  end
end
