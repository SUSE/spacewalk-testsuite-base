#! /bin/bash

# simply patch to make chrome on suse

# Versions
zypper in curl
CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`
SELENIUM_STANDALONE_VERSION=3.4.0
SELENIUM_SUBDIR=$(echo "$SELENIUM_STANDALONE_VERSION" | cut -d"." -f-2)

## Install Chrome.

chrome_install() {
  wget https://dl.google.com/linux/linux_signing_key.pub
  rpm --import linux_signing_key.pub
  wget -N https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm  
  zypper in google-chrome-stable_current_x86_64.rpm  
}
## Install ChromeDriver.
chrome_driver() {
  wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/
  unzip ~/chromedriver_linux64.zip -d ~/
  rm ~/chromedriver_linux64.zip
  sudo mv -f ~/chromedriver /usr/local/bin/chromedriver
  sudo chown root:root /usr/local/bin/chromedriver
  sudo chmod 0755 /usr/local/bin/chromedriver
}

dependency() {
  zypper -n in libgtk-3-0 libnsssharedhelper0 libgconfmm-2_6-1
}
#
chrome_install
chrome_driver

# try out if works without this
# dependency

# need update
gem update selenium-webdriver
