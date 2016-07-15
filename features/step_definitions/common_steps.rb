# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

When(/^I wait for "(\d+)" seconds$/) do |arg1|
  sleep(arg1.to_i)
end

When(/^I run rhn_check on this client$/) do
  output, _local, _remote, code = $client.test_and_store_results_together("rhn_check -vvv", "root", 400)
  if code != 0
      raise "rhn_check failed: #{$!}: #{output}"
  end
end

Then(/^I download the SSL certificate$/) do
  # download certicate on the client from the server via ssh protocol
  cert_path = "/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT"
  wget = "wget --no-check-certificate -o"
  _out, loc, rem, c = $client.test_and_print_results("#{wget} #{cert_path} http://#{$server_ip}/pub/RHN-ORG-TRUSTED-SSL-CERT", "root", 500)

  if c != 0 && loc != 0 && rem != 0
    raise "fail to download the ssl certificate"
  end
  _out, _local, _remote, _code = $client.test_and_print_results("ls #{cert_path}", "root", 500)
end
