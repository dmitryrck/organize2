Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless") if ENV.fetch("CAPYBARA_HEADLESS") { "yes" } == "yes"
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ActiveRecord::Type::Boolean.new.cast(ENV["CI"] || "false")
      driven_by :chrome_headless
    else
      driven_by :selenium, using: :firefox
    end
  end
end
