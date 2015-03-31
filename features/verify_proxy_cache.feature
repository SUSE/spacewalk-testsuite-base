# Copyright (c) 2015 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Verify the proxy cache after package installation

  Scenario: Reinstall package to be sure we fetch it twice
     Then I remove the "hoag-dummy" package
     And I am on the Systems overview page of this client
     And I follow "Software" in the content area
     And I follow "Install"
    When I check "hoag-dummy-1.1-2.1" in the list
     And I click on "Install Selected Packages"
     And I click on "Confirm"
     And I run rhn_check on this client
    Then I should see a "1 package install has been scheduled for" text
     And "hoag-dummy-1.1-2.1" is installed

  Scenario: I want to verify the rpm is cached on the proxy
     Then I remove the "hoag-dummy" package
     And I am on the Systems overview page of this client
     And I follow "Software" in the content area
     And I follow "Install"
    When I check "hoag-dummy-1.1-2.1" in the list
     And I click on "Install Selected Packages"
     And I click on "Confirm"
     And I run rhn_check on this client
    Then I should see a "1 package install has been scheduled for" text
     And "hoag-dummy-1.1-2.1" is installed
     And I verify the proxy cache
