ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  RubyObject.reindex
  RubyMethod.reindex

  # and disable callbacks
  Searchkick.disable_callbacks

  # Add more helper methods to be used by all tests here...
end
