# Copyright (c) 2017 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Migrate a traditional client into a salt minion

  Scenario: Migrate a sles client into a salt minion
     Given I am authorized
     When I follow "Salt"
     Then I should see a "Bootstrapping" text
     And I follow "Bootstrapping"
     Then I should see a "Bootstrap Minions" text
     # sle-client = traditional sles client
     And I enter the hostname of "sle-client" as hostname
     And I enter "22" as "port"
     And I enter "root" as "user"
     And I enter "linux" as "password"
     And I select "1-SUSE-PKG-x86_64" from "activationKeys"
     And I click on "Bootstrap"
     And I wait for "100" seconds
     Then I should see a "Successfully bootstrapped host! Your system should appear in System Overview shortly." text

  Scenario: Verify the minion was bootstrapped with activation key
     Given I am on the Systems overview page of this "sle-client"
     Then I should see a "Activation Key: 	1-SUSE-PKG" text

  Scenario: Check that service nhsd has been stopped
     # bsc#1020902 - moving from traditional to salt with bootstrap is not disabling rhnsd
     When I run "systemctl status nhsd | grep Active" on "sle-client"
     Then the command should fail

