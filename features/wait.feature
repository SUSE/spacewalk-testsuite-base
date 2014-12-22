Feature: To prevent race conditions
  In package parsing
  As the admin user
  I want to wait

Scenario: wait to workaround race conditions 
     When I wait for "120" seconds
      And I wait for "120" seconds
      And I wait for "120" seconds
      And I wait for "120" seconds

