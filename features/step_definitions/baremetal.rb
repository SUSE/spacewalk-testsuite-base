When(/^I check the ram value$/) do
   get_ram_value = `grep MemTotal /proc/meminfo |awk '{print $2}'`
   ram_value, _local, _remote, _code = $client.test_and_store_results_together(get_ram_value, "root", 600)
   ram_value = ram_value.gsub(/\s+/, "")
   ram_mb = ram_value.to_i / 1024
   step %(I should see a "#{ram_mb}" text)
end

When(/^I check the MAC address value$/) do
   get_mac_address = `ifconfig | grep eth0 | awk '{print $5}'`
   mac_address, _local, _remote, _code = $client.test_and_store_results_together(get_mac_address, "root", 600)
   mac_address = mac_address.gsub(/\s+/, "")
   mac_address.downcase!
   step %(I should see a "#{mac_address}" text)
end

Then(/^I should see the CPU frequency of the client$/) do
   get_cpu_freq = `cat /proc/cpuinfo  | grep MHz | awk '{print $4}'`
   cpu_freq, _local, _remote, _code = $client.test_and_store_results_together(get_cpu_freq, "root", 600)
   cpu_freq = cpu_freq.gsub(/\s+/, "")
   step %(I should see a "#{cpu_freq.to_i / 1000} GHz" text)
end
