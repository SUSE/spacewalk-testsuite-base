# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

Feature: sm-ncc-sync channel listing and enablement
  In Order to validate correct working of sm-ncc-sync
  As user root
  I want to be able to list available channels and enable them

  Scenario: enable sles11-sp3-suse-manager-tools-x86_64
     When I execute ncc-sync "--channel sles11-sp3-suse-manager-tools-x86_64"
      And I execute ncc-sync "--list-channels"
     Then I want to get "    [P] sles11-sp3-suse-manager-tools-x86_64"

  Scenario: enable sles11-sp3-updates-x86_64
     When I execute ncc-sync "--add-product-by-ident suse-linux-enterprise-server-11-sp2-x86_64-3009-sles11-sp1-pool-x86_64"
      And I execute ncc-sync "--list-channels"
     Then I want to get "[P] sles11-sp1-pool-x86_64"
      And I want to get "    [P] sles11-sp2-updates-x86_64"

