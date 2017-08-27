require "capybara/rspec"
require "capybara/poltergeist"

Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist

module Helpers
  # :nocov:
  def sign_in(user = nil)
    user ||= create(:admin_user)

    visit admin_root_path

    fill_in "Email*", with: user.email
    fill_in "Password*", with: "secret"

    click_button "Login"

    visit admin_root_path
  end
  # :nocov:
end

RSpec.configure do |config|
  config.include Helpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
end
