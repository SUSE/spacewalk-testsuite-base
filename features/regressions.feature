# Copyright (c) 2015 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Regression tests 
  In Order to validate the package summary of a package in the metadata
  As an authorized user
  I want to see the summary do not contain a \n at the end

  Background:
    Given I am testing channels

  #bug 821968  Scenario: Check local metdata not contain \n at the end of the summary
    And I am root
    When I refresh the metadata
    Then I should have 'summary.*</summary' in the metadata
