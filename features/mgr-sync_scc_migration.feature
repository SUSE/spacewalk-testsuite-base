# Copyright (c) 2014 SUSE
# Licensed under the terms of the MIT license.

Feature: sm-mgr-sync scc migration, channel listing and enablement
  In order to validate correct working of sm-mgr-sync
  As user root
  I want to be able to migrate sm from ncc to scc

  Scenario: migrate to scc
     Given file "/root/.mgr-sync" exists on server
     And file "/root/.mgr-sync" doesn't contain "mgrsync.user"
     And SCC feature is enabled
     When I execute mgr-sync "enable-scc"
      Then I want to get "SCC backend successfully migrated."
      And file "/var/lib/spacewalk/scc/migrated" exists on server

  Scenario: previously enabled channels are still enabled
     When I execute mgr-sync "list channels --compact --expand"
     Then I want to get "[I] sles11-sp3-pool-x86_64"
      And I want to get "    [I] sles11-sp3-updates-x86_64"

  Scenario: list available channels
     When I execute mgr-sync "list channels --compact"
     Then I want to get "[ ] sles12-pool-x86_64"

  Scenario: enable sles12-pool-x86_64
     When I execute mgr-sync "add channel sles12-pool-x86_64"
      And I execute mgr-sync "list channels --compact"
     Then I want to get "[I] sles12-pool-x86_64"
