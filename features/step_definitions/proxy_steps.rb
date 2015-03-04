Then /^I register the proxy$/ do
  act_key = '--activationkey=1-SUSE-proxy'
  url = "--serverUrl=https://#{ENV['TESTHOST']}/XMLRPC"
  cert = "http://#{ENV['TESTHOST']}/pub/RHN-ORG-TRUSTED-SSL-CERT"
  dest = '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT'
  #download certificate and silence output
  sshcmd("wget #{cert} -O #{dest} -o /dev/null", host: ENV['PROXY_APP'])
  step 'I rehash the certificates'
  sshcmd("rhnreg_ks #{url} #{act_key}", host: ENV['PROXY_APP'])
end

Then /^I run the proxy setup$/ do
  cmd = "/usr/sbin/configure-proxy.sh --answer-file=/root/proxy_answers --non-interactive"
  sshcmd(cmd, host: ENV['PROXY_APP'])
end

Then /^I copy the ssl certs$/ do
  certs = "/root/ssl-build/{RHN-ORG-PRIVATE-SSL-KEY,RHN-ORG-TRUSTED-SSL-CERT,rhn-ca-openssl.cnf}"
  dest = "/root/ssl-build"
  scpcmd = "scp -o StrictHostKeyChecking=no '#{ENV['TESTHOST']}:#{certs}' #{dest} &> /dev/null"
  sshcmd("mkdir /root/ssl-build", host: ENV['PROXY_APP'])
  sshcmd(scpcmd, host: ENV['PROXY_APP'])
end


Then /^I should be setup$/ do
  sshcmd('pgrep squid', host: ENV['PROXY_APP']) 
  sshcmd('test -x /etc/sysconfig/rhn/systemid', host: ENV['PROXY_APP']) 
end

Then /^I rehash the certificates$/ do
  symbolic_link_cmd = 'ln -s /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT /etc/ssl/certs/RHN-ORG-TRUSTED-SSL-CERT.pem'
  rehash_cmd = 'c_rehash /etc/ssl/certs/'
  sshcmd(symbolic_link_cmd, host: ENV['PROXY_APP'])
  sshcmd(rehash_cmd, host: ENV['PROXY_APP'])
end

Then /^I should see a proxy link in the content area$/ do
  step "I should see a \"#{ENV['PROXY_APP']}\" link in the content area"
end

Then /^I remove the "([^"]*)" package$/ do |pkg|
  $command_output = `zypper --non-interactive rm #{pkg}`
  if ! $?.success?
    raise "Removing package #{pkg} failed"
  end  
end

Then /^I verify the proxy cache$/ do
  squid_log = "/var/log/squid/access.log"
  cmd = "grep 'TCP_MEM_HIT/200' #{squid_log}"
  out = sshcmd(cmd, host: ENV['PROXY_APP'], ignore_err: true)
  fail if ! out[:stdout].include? "hoag-dummy"
end
