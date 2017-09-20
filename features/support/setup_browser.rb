# Copyright (c) 2010-2017 SUSE-LINUX
# Licensed under the terms of the MIT license.

require 'English'
require 'rubygems'
require 'tmpdir'
require 'base64'
require 'capybara'
require 'capybara/cucumber'
require File.join(File.dirname(__FILE__), 'cobbler_test')
require 'simplecov'
require 'minitest/unit'
require 'selenium-webdriver'
# FIXME: this 2 variable why, for what are the set?
ENV['LANG'] = 'en_US.UTF-8'
ENV['IGNORECERT'] = '1'

## codecoverage gem
SimpleCov.start
server = ENV['TESTHOST']
# 10 minutes maximal wait before giving up
# the tests return much before that delay in case of success
DEFAULT_TIMEOUT = 600
$stdout.sync = true
Capybara.default_wait_time = 10

def enable_assertions
  # include assertion globally
  World(MiniTest::Assertions)
end

def restart_driver
  session_pool = Capybara.send('session_pool')
  session_pool.each_value do |session|
    driver = session.driver
    driver.restart
  end
end

Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1920,1080 disable-web-security ignore-certificate-errors remote-debugging-port=9222] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
  #    js_errors: false,
  #    timeout: 250,
  #    window_size: [1920, 1080],
  #    debug: false)
end

# Setups browser driver with capybara/poltergeist
Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome
Capybara.app_host = "https://#{server}"

# don't run own server on a random port
Capybara.run_server = false
# At moment we have only phantomjs
# FIXME
# screenshots
# After do |scenario|
#  if scenario.failed?
#    encoded_img = page.driver.render_base64(:png, full: true)
#    embed("data:image/png;base64,#{encoded_img}", 'image/png')
#  end
# end

# restart always before each feature, we spare ram and
# avoid ram issues!
Before do
  restart_driver
end

# with this we can use in steps minitest assertions
enable_assertions
