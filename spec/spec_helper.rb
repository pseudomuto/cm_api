# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "coveralls"
Coveralls.noisy = true
Coveralls.wear!

require "cm_api"
require "vcr"
require "webmock/rspec"
Dir["./spec/support/**/*.rb"].each { |f| require f }

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir                    = "spec/cassettes"

  c.configure_rspec_metadata!
  c.hook_into(:webmock)
end
