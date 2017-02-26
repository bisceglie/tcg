require File.expand_path '../spec_helper.rb', __FILE__

describe TwitterClient::Cache do
  let(:cache) {
    TwitterClient::Cache.new()
  }
  
  it 'should work like an LRU cache' do
    expect(cache.cached(:key1)).to be(nil)
    expect(cache.cached(:key1) {:val1}).to eq(:val1)
    expect(cache.cached(:key1)).to eq(:val1)

    expect(cache.cached(:key2)).to be(nil)
    expect(cache.cached(:key1)).to eq(:val1)
    expect(cache.cached(:key2) {:val2}).to eq(:val2)
    expect(cache.cached(:key2)).to eq(:val2)

    expect(cache.cached(:key3)).to be(nil)
    expect(cache.cached(:key3) {:val3}).to be(nil)
    expect(cache.cached(:key1)).to eq(:val1)
    expect(cache.cached(:key2)).to eq(:val2)
    
    Timecop.freeze(Date.today + 30) do
      expect(cache.cached(:key1)).to eq(:val1)
      expect(cache.cached(:key2)).to eq(:val2)
      expect(cache.cached(:key3) {:val3}).to eq(:val3)
      expect(cache.cached(:key1)).to be(nil)
      expect(cache.cached(:key1) {:val1}).to be(nil)
      expect(cache.cached(:key2)).to eq(:val2)
      expect(cache.cached(:key2)).to eq(:val2)
    end
  end
end
