# Copyright (c) 2015 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Enable some extra channels
  In order to test better
  As user root
  I want to enable some more channels

  Scenario: enable sles12 product
     When I execute mgr-sync "add channel sles12-updates-x86_64"
      And I execute mgr-sync "add channel sle-manager-tools12-pool-x86_64"
      And I execute mgr-sync "add channel sle-manager-tools12-updates-x86_64"
      And I execute mgr-sync "list channels --compact"
      Then I want to get "[I] sles12-updates-x86_64"

