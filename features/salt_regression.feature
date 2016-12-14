# Copyright (c) 2015-16 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Test Salt for regression

   Scenario: There are no top.sls file in certain folders
   When  I run "ls /srv/susemanager/salt/top.sls" on "server"
   Then the command should fail
   
   When  I run "ls /srv/susemanager/salt/top.sls" on "server"
   Then the command should fail

   When  I run "ls /srv/susemanager/pillar/top.sls" on "server"
   Then the command should fail

   When  I run "ls /usr/share/susemanager/salt/top.sls" on "server"
   Then the command should fail

   When  I run "ls /usr/share/susemanager/pillar/top.sls" on "server"
   Then the command should fail
   # BUG : 993209
   Scenario:  Manager Hangs if a registered salt-minion is down
    Given I am authorized as "testing" with password "testing"
    And I follow "Salt"
    And I follow "Remote Commands"
    And I should see a "Remote Commands" text
    And I run "systemctl stop salt-minion" on "rh-minion"
    And I enter command "cat /etc/os-release"
    And I click on preview
    Then I should see "rh-minion" hostname
    And I run "systemctl restart salt-minion" on "rh-minion"

