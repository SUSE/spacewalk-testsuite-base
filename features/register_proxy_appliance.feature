# Copyright (c) 2015 SUSE LLC.  
# Licensed under the terms of the MIT license.

Feature: I want to setup the proxy appliance
  
  Scenario: Create an activation key for the proxy
    Given I am on the Systems page
      And I follow "Activation Keys" in the left menu
      And I follow "Create Key"  
      When I enter "SUSE proxy appliance" as "description"
      And I enter "SUSE-proxy" as "key"
      When I select "SUSE-Manager-Proxy-2.1-Pool for x86_64" from "selectedChannel"
      And I check "monitoring_entitled"
      And I check "provisioning_entitled" 
      And I click on "Create Activation Key"
      And I should see a "Activation key SUSE proxy appliance has been created." text
      And I follow "Child Channels" in the content area
      And I check "SUSE-Manager-Proxy-2.1-Updates for x86_64"
      And I click on "Update Key"
      Then I should see a "Activation key SUSE proxy appliance has been modified" text

  Scenario: I run the proxy setup
    When I register the proxy
    And I copy the ssl certs
    And I run the proxy setup
  
  Scenario: The proxy should be setup and registered
    Given I am on the Systems page
      And I follow "Systems" in the left menu
      And I follow "Proxy" in the left menu
      And I should see a proxy link in the content area
      Then I should be setup
