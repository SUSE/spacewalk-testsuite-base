# Copyright (c) 2016 SUSE Linux
# Licensed under the terms of the MIT license.

Then(/^I control that up2date logs on client under test contains no Traceback error$/) do
  check_up2date = "grep \"Traceback\" /var/log/up2date"
  $client.run(check_up2date)
end
