# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

When(/^I refresh the metadata$/) do
  $client.run("rhn_check -vvv", true, 500, 'root')
  client_refresh_metadata
end

Then(/^I should have '([^']*)' in the metadata$/) do |text|
  # FIXME: this work but should fixed
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  cmd = "zgrep '#{text}' #{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/primary.xml.gz"
  $client.run(cmd, true, 500, 'root')
end

Then(/^I should not have '([^']*)' in the metadata$/) do |text|
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  cmd = "zgrep '#{text}' #{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/primary.xml.gz"
  _out, _local, _remote, code = $client.test_and_store_results_together(cmd, "root", 500)
  fail if code != 0
end

Then(/^"([^"]*)" should exists in the metadata$/) do |file|
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  fail unless file_exist($client, "#{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/#{file}")
end

Then(/^I should have '([^']*)' in the patch metadata$/) do |text|
  # FIXME: change arch also here
  arch = `uname -m`
  arch.chomp!
  if arch != "x86_64"
    arch = "i586"
  end
  cmd = "zgrep '#{text}' #{client_raw_repodata_dir("sles11-sp3-updates-#{arch}-channel")}/updateinfo.xml.gz"
  $client.run(cmd, true, 500, 'root')
end
