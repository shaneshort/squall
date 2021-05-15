require 'rspec'
require 'vcr'
require 'squall'
require 'cgi'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  # c.debug_logger = $stdout
  c.hook_into :webmock
  if ENV['RERECORD']
    c.default_cassette_options = {record: :all}
  else
    c.default_cassette_options = {record: :none}
  end
  c.filter_sensitive_data("Basic <REDACTED>") { |i| [i.request.headers['authorization']].flatten.first }
  c.filter_sensitive_data("<REDACTED>") { |i| [i.response.headers['set-cookie']].flatten.first }
  c.filter_sensitive_data("<URL>") { URI.parse(Squall.config[:base_uri]).host }
  c.filter_sensitive_data("<USER>") { Squall.config[:username] }
  c.filter_sensitive_data("<PASS>") { Squall.config[:password] }

  c.register_request_matcher :ignore_query_param_ordering do |r1, r2|
    uri1 = URI(r1.uri)
    uri2 = URI(r2.uri)

    uri1.scheme == uri2.scheme &&
      uri1.host == uri2.host &&
        uri1.path == uri2.path &&
          CGI.parse(uri1.query||'') == CGI.parse(uri2.query||'')
  end
end

RSpec.configure do |c|
  c.before(:each) do
    configure_for_tests
  end
  c.after(:each) do
    Squall.reset_config
  end
end

def configure_for_tests
  if ENV['RERECORD']
    Squall.config_file
  else
    Squall.config do |c|
      c.username "test"
      c.password "test"
      c.base_uri "http://example.com"
    end
  end
end

def mock_request(meth, path, options = {})
  config = Squall.config
  uri    = URI.parse(config[:base_uri])
  url    = "#{uri.scheme}://#{config[:username]}:#{config[:password]}@#{uri.host}:#{uri.port}#{path}"
end
