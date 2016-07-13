# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

When(/^I refresh the metadata$/) do
  output = `rhn_check -vvv 2>&1`
    unless $?.success?
      raise "rhn_check failed: #{$!}: #{output}"
    end
  client_refresh_metadata
end

Then(/^I should have '([^']*)' in the metadata$/) do |text|
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  `zgrep '#{text}' #{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/primary.xml.gz`
  fail unless $?.success?
end

Then(/^I should not have '([^']*)' in the metadata$/) do |text|
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  `zgrep '#{text}' #{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/primary.xml.gz`
  fail if $?.success?
end

Then(/^"([^"]*)" should exists in the metadata$/) do |file|
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  fail unless File.exist?("#{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/#{file}")
end

Then(/^I should have '([^']*)' in the patch metadata$/) do |text|
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  `zgrep '#{text}' #{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/updateinfo.xml.gz`
  fail unless $?.success?
end
