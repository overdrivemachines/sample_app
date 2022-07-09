ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in.
  # Same is logged_in? as defined in sessions_helper.rb. Helper method logged_in?
  # is not accessible in tests.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Including the Application helper in tests.
  include ApplicationHelper
end
