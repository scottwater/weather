ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "mocha/minitest"
require "minitest/mock"
require "rails/test_help"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/support/vcr_cassettes"
  config.hook_into :webmock
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
