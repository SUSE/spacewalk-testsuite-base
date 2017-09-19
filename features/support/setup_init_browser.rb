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
require 'capybara/poltergeist'
require 'minitest/unit'

SimpleCov.start
server = ENV['TESTHOST']
# 10 minutes maximal wait before giving up
# the tests return much before that delay in case of success
DEFAULT_TIMEOUT = 600
$stdout.sync = true
Capybara.default_wait_time = 10

# FIXME: this 2 variable why, for what are they set?
ENV['LANG'] = 'en_US.UTF-8'
ENV['IGNORECERT'] = '1'

def enable_assertions
  # include assertion globally
  World(MiniTest::Assertions)
end

def restart_phantomjs
  session_pool = Capybara.send('session_pool')
  session_pool.each do |_mode, session|
    driver = session.driver
    driver.restart if driver.is_a?(Capybara::Poltergeist::Driver)
  end
end

def capybara_setup_driver(driver, server)
  Capybara.default_driver = driver.to_sym
  Capybara.javascript_driver = driver.to_sym
  Capybara.app_host = "https://#{server}"
  # don't run own server on a random port
  Capybara.run_server = false
end

# Returns current url
def current_url
  driver.current_url
end

# Main
# Setups browser
Setup browser: phantomjs
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
                                    phantomjs_options: ['--debug=no',
                                                        '--ignore-ssl-errors=yes',
                                                        '--ssl-protocol=TLSv1',
                                                        '--web-security=false'],
                                    js_errors: false,
                                    timeout: 250,
                                    window_size: [1920, 1080],
                                    debug: false)
end

capybara_setup_driver('poltergeist', server)

# screenshots
After do |scenario|
  if scenario.failed?
    encoded_img = page.driver.render_base64(:png, full: true)
    embed("data:image/png;base64,#{encoded_img}", 'image/png')
  end
end

# restart always before each feature, we spare ram and
# avoid ram issues!
Before do
  restart_phantomjs
end

# with this we can use in steps minitest assertions
enable_assertions
