# Copyright (c) 2017 SUSE LLC
# Licensed under the terms of the MIT license.

Feature:  Build Container images with SUSE Manager. Basic image
          Images are not with zypper and doesn't contains the name
          of the server. So the inspect functionality is not tested here.

  Scenario: Assign to the sles-minion the property container build host 
  Given I am on the Systems overview page of this "sle-minion"
  And I follow "Details" in the content area
  And I follow "Properties" in the content area
  And I check "container_build_host"
  When I click on "Update Properties"
  Then I should see a "Container Build Host type has been applied." text 
  And I should see a "Note: This action will not result in state application" text
  And I should see a "To apply the state, either use the states page or run `state.highstate` from the command line." text
  And I should see a "System properties changed" text

  Scenario: Apply the highstate to container buid host
  Given I am on the Systems overview page of this "sle-minion"
  Then I should see a "[Container Build Host]" text
  And I run "zypper mr -e Devel_Galaxy_Manager_Head_SLE-Manager-Tools-12-x86_64" on "sle-minion"
  And I run "zypper mr -e SUSE_Updates_SLE-Module-Containers_12_x86_64" on "sle-minion"
  And I run "zypper mr -e SUSE_Pool_SLE-Module-Containers_12_x86_64" on "sle-minion"
  And I run "zypper mr -e SLE-12-SP2-x86_64-Pool" on "sle-minion"
  And I run "zypper mr -e SLE-12-SP2-x86_64-Update" on "sle-minion"
  And I run "zypper -n --gpg-auto-import-keys ref" on "sle-minion"
  And I apply highstate on Sles minion
  Then I wait until "docker" service is up and running on "sle-minion"
  # FIXME: We need a test for image store with credentials
  Scenario: Create an Image Store without credentials
  Given I am authorized as "admin" with password "admin"
  And I follow "Images" in the left menu
  And I follow "Stores" in the left menu
  And I follow "Create"
  And I enter "galaxy-registry" as "label"
  And I enter "registry.mgr.suse.de" as "uri"
  And I click on "create-btn"
  
  #Fixme
##  Scenario: Image Store GUI validation: wrong label
#  Given I am authorized as "admin" with password "admin"
#  And I follow "Images" in the left menu
#  And I follow "Stores" in the left menu
#  And I enter "${uptime!**_+}" as "label"
#  And I enter "registry.mgr.suse.de" as "uri"
#  And I click on "create-btn"
#
#  Scenario: Image Store GUI validation: missing parameter
#  Given I am authorized as "admin" with password "admin"
#  And I follow "Images" in the left menu
#  And I follow "Stores" in the left menu
#  And I enter "${uptime!**_+}" as "label"
#  And I click on "create-btn"
#
  Scenario: Create a simple Image profile without act-key
  Given I am authorized as "admin" with password "admin"
  And I follow "Images" in the left menu
  And I follow "Profiles" in the left menu
  And I follow "Create"
  And I enter "suse_simply" as "label"
  And I select "galaxy-registry" from "imageStore"
  And I enter "https://gitlab.suse.de/galaxy/suse-manager-containers.git#:test-profile" as "path"
  And I click on "create-btn"

# Scenario: Image profile validation: wrong label
#  Given I am authorized as "admin" with password "admin"
#  And I follow "Images" in the left menu
#  And I follow "Profiles" in the left menu
#  And I follow "Create"
#  And I enter "${uptime!**_+}" as "label"
#  And I select "galaxy-registry" from "imageStore"
#  And I enter "https://gitlab.suse.de/galaxy/suse-manager-containers.git#:test-profile" as "path"
#  And I click on "create-btn"
#
# Scenario: Image profile validation: wrong path
#  Given I am authorized as "admin" with password "admin"
#  And I follow "Images" in the left menu
#  And I follow "Profiles" in the left menu
#  And I follow "Create"
#  And I enter "suse_simply2" as "label"
#  And I select "galaxy-registry" from "imageStore"
#  And I enter "/root/linuxPinguinols" as "path"
#  And I click on "create-btn"
#
# Scenario: Image profile validation: missing parameter
#  Given I am authorized as "admin" with password "admin"
#  And I follow "Images" in the left menu
#  And I follow "Profiles" in the left menu
#  And I follow "Create"
#  And I enter "suse_simply2" as "label"
#  And I select "galaxy-registry" from "imageStore"
#  And I click on "create-btn"
#
  Scenario: Create an Image profile with activation-key
  Given I am authorized as "admin" with password "admin"
  And I follow "Images" in the left menu
  And I follow "Profiles" in the left menu
  And I follow "Create"
  And I enter "suse_key" as "label"
  And I select "galaxy-registry" from "imageStore"
  And I select "1-MINION-TEST" from "activationKey"
  And I enter "https://gitlab.suse.de/galaxy/suse-manager-containers.git#:test-profile" as "path"
  And I click on "create-btn"

  Scenario: Build the simply images (no hostname inside) with and without activation key
  Given I am authorized as "admin" with password "admin"
  # At moment phantomjs has problemes with datapickler so we use xmlrpc-api
  And I schedule the build of image "suse_key" via xmlrpc-call  
  And I schedule the build of image "suse_simply" via xmlrpc-call  

  # Scenario: Build an Image via gui

  Scenario: Build same images with different tags
  Given I am authorized as "admin" with password "admin"
  And I schedule the build of image "suse_key" with tag "Latest_key-activation1" via xmlrpc-call 
  And I schedule the build of image "suse_simply" with tag "Latest_simply" via xmlrpc-call 
  # FIXME: Can we verify via xmplrpc the status of images? build or not?
  # then we can remove the sleep.
  And I wait for "50" seconds

  Scenario: Verify the status of images.
  Given I am authorized as "admin" with password "admin"
  And I navigate to images build webpage
  Then I verify that all container images were built correctly in the gui
  
  #FIXME: TO IMPLEMENT
#  Scenario: Verify that all inspect jobs are executed failed or not
#  Given I am authorized as "admin" with password "admin"

  Scenario: Delete tagged images via xmlrpc
  Given I am authorized as "admin" with password "admin"
  Then I delete the image "suse_key" via xmlrpc-call

#  Scenario: Delete image via gui
#  Given I am authorized as "admin" with password "admin"

# TODO1: 
  Scenario: Create an Image profile with suse-manager server hostname
  Given I am authorized as "admin" with password "admin"
  And I follow "Images" in the left menu
  And I follow "Profiles" in the left menu
  And I follow "Create"
  And I enter "Realsuse" as "label"
  And I select "galaxy-registry" from "imageStore"
  #FIXME: create the stuff on gitllab
  #FIXME: just use test-branch for testing other branch then master
  And I enter "https://gitlab.suse.de/galaxy/suse-manager-containers.git#:test-profile-inspect" as "path"
  And I click on "create-btn"
 
  Scenario: Create an Image profile with activation-key and serverhostname
  Given I am authorized as "admin" with password "admin"
  And I follow "Images" in the left menu
  And I follow "Profiles" in the left menu
  And I follow "Create"
  And I enter "Realsuse_key" as "label"
  And I select "galaxy-registry" from "imageStore"
  And I select "1-MINION-TEST" from "activationKey"
  #FIXME: create the stuff on gitllab
  #FIXME: just use test-branch for testing other branch then master
  And I enter "https://gitlab.suse.de/galaxy/suse-manager-containers.git#:test-profile-inspect" as "path"
  And I click on "create-btn"

  #FIXME: this will not work locally at moment because
  # we hardcode the hostname inside the images !
#  Scenario: Build the real images with and without activation key
#  Given I am authorized as "admin" with password "admin"
  # At moment phantomjs has problemes with datapickler so we use xmlrpc-api
#  And I schedule the build of image "Realsuse" via xmlrpc-call  
#  And I schedule the build of image "Realsuse_key" via xmlrpc-call  
#  And I schedule the build of image "Realsuse" with tag "metally-version" via xmlrpc-call 
#  And I schedule the build of image "Realsuse_key" with tag "jazzy-version" via xmlrpc-call 

#  Scenario: Verify the effects of activation-key on image
#  Given I am authorized as "admin" with password "admin"
