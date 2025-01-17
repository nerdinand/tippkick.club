ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'time_travelers'

class ActiveSupport::TestCase
  include TimeTravelers
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def reset_bet(bet)
    bet.update_columns(home_team_score: nil, guest_team_score: nil)
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in_as(fixture_key)
    sign_in users(fixture_key)
  end

  def sign_in_as_admin(fixture_key)
    user = users(fixture_key)
    user.update(admin: true)
    sign_in_as(fixture_key)
  end
end
