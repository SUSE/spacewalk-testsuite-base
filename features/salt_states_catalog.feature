# Copyright (c) 2016 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Check the Salt package state UI
  In Order to test salt states catalog
  As the testing user

  Scenario: I add a state through the UI
    Given I am authorized as "testing" with password "testing"
    Then I follow "Salt"
    And I follow "State Catalog"
    And I should see a "State Catalog" text
    And I follow "Create State"
    Then I should see a "Create State" text
    And I should see a "Name*:" text
    And I should see a "Content*:" text
    And I enter "dockerstate" in the css "input[name='name']"
    And I enter the salt state
      """
      inst_ca-certificates:
        pkg.installed:
          - name: ca-certificates
      
      registry_cert:
        file.managed:
          - name: /etc/pki/trust/anchors/registry.mgr.suse.de.pem
          - source: salt://dockerhost/registry.mgr.suse.de.pem
          - makedirs: True
      
      suse_cert:
        file.managed:
          - name: /etc/pki/trust/anchors/SUSE_Trust_Root.crt.pem
          - source: salt://dockerhost/SUSE_Trust_Root.crt.pem
          - makedirs: True
      
      update_ca_truststore:
        cmd.wait:
          - name: /usr/sbin/update-ca-certificates
          - watch:
            - file: registry_cert
            - file: suse_cert
          - require:
            - pkg: inst_ca-certificates
      
      docker_restart:
        service.running:
          - name: docker
          - watch:
            - cmd: update_ca_truststore
            - file: suse_cert
            - file: registry_cert
      
      """
    And I click on the css "button#save-btn"
    Then I should see a "State 'dockerstate' saved" text

  Scenario: I add a apply a state via the UI
    Given I am on the Systems overview page of this "sle-minion"
    And I follow "States"
    Then I follow "Custom"
    And I should see a "Custom States" text
    And I click on the css "button#search-states"
    Then I should see a "dockerstate" text
    And I select the state "dockerstate"
    Then I should see a "1 Changes" text
    And I click on the css "button#save-btn"
    And I click on the css "button#apply-btn"
    Then "/etc/pki/trust/anchors/SUSE_Trust_Root.crt.pem" exists on the filesystem of "sle-minion"
