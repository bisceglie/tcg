require 'rack/test'
require 'rspec'
require 'timecop'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../lib/twitter_client', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() TwitterClient::App end
end  

RSpec.configure { |c| c.include RSpecMixin }

