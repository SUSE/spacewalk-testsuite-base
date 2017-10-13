# Copyright (c) 2017 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Systems in "Configuration => Systems => Target Systems" page

  Scenario: Check absence of the minion in the list
      Given I am on the Configuration => Systems => Target systems page
      And I type "sle-minion" in the search box and click "Go"
      Then I should see a "No non-managed systems." text
