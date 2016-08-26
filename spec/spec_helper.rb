# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "coveralls"
Coveralls.noisy = true
Coveralls.wear!

require "cm_api"
require "webmock/rspec"
Dir["./spec/support/**/*.rb"].each { |f| require f }
