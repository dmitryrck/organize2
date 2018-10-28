Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[no-sandbox headless disable-popup-blocking disable-gpu]
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome
