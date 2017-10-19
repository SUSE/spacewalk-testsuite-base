# Copyright (c) 2017 SUSE LLC
# Licensed under the terms of the MIT license.
#
# The scenarios in this feature are skipped if there is no proxy
# ($proxy is nil)

Feature: Setup SUSE Manager proxy
  In order to use a proxy with the SUSE manager server
  As the system administrator
  I want to register the proxy to the server

@proxy
  Scenario: Register the proxy
    # Add step to create bootstrap script on server here
    # Add step to download bootstrap script from server to proxy here
    # Add step to run the bootstrap script on proxy here
    # These steps are currently performed by sumaform
    Then I should see "proxy" in spacewalk

@proxy
  Scenario: Check proxy system details
    When I am on the Systems overview page of this "proxy"
    Then I should see "proxy" hostname
    And I should see a "SUSE Manager Proxy" text
