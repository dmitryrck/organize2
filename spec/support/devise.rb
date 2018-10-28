module Login
  module Helpers
    def sign_in(user)
      visit admin_root_path

      fill_in "Email", with: user.email
      fill_in "Password", with: "secret"

      click_on "Login"

      expect(page).to have_content "Signed in successfully."

      expect(page).to have_content user.email
    end
  end
end

RSpec.configure do |config|
  config.include Login::Helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
end
