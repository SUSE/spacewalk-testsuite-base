# Copyright (c) 2016 SUSE Linux
# Licensed under the terms of the MIT license.

Then(/^I check the up2date logs on client$/) do
  check_up2date = "grep \"Traceback\" /var/log/up2date"
  _out, _loc, _rem, code = $client.test_and_print_results(check_up2date, "root", 500)
  if code != 0
    raise "FAIL: ERRORS founds on  up2date log: check /var/log/up2date on client!"
  end
end
