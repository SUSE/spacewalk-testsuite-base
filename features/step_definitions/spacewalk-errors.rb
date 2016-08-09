# Copyright (c) 2016 SUSE Linux
# Licensed under the terms of the MIT license.

Then(/^I check the up2date logs on client$/) do
  check_up2date = "grep \"Traceback\" /var/log/up2date"
  _out, _loc, _rem, code = $client.test_and_print_results(check_up2date, "root", 500)
  if code != 0
    out, _loc, _rem, _code = $client.test_and_print_results("grep -n30 \"Traceback\" /var/log/up2date")
    raise "TEST_FAILED : ERRORS founds on  up2date log_file !!  : #{out}"
  end
end
