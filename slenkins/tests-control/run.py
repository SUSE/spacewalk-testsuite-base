#! /usr/bin/python

import subprocess
import sys
import traceback
import twopence
import susetest
import suselog
from susetest_api.assertions import *
from susetest_api.files import *
journal = None
suite = "/var/lib/slenkins/tests-suse-manager"
client = None
server = None
minion = None

def setup():
    global client, server, journal, minion

    config = susetest.Config("tests-suse-manager")
    journal = config.journal

    client = config.target("client")
    server = config.target("server")
    minion = config.target("minion")

def client_setup():
        init_client = ''' zypper ar http://dist.suse.de/install/SLP/SUSE-Manager-Tools-3-GM/x86_64/DVD1/ suma3-gmc-tools;  zypper -n --gpg-auto-import-keys ref; 
                        zypper -n in subscription-tools;
                        zypper -n in spacewalk-client-setup;
                        zypper -n in spacewalk-check; 
                        zypper -n in spacewalk-oscap; 
			zypper -n in rhncfg-actions'''
        run_cmd(client, init_client, "init client", 600)
	run_cmd(client, " zypper -n in andromeda-dummy milkyway-dummy virgo-dummy", "install dummy package needed by tests", 900)
        run_cmd(client, "echo \"{}     suma-server.example.com\" >> /etc/hosts;" .format(server.ipaddr), "setup host", 300)
def setup_server():		
	change_hostname = "echo \"{}     suma-server.example.com\" >> /etc/hosts; echo \"suma-server.example.com\" > /etc/hostname;  hostname -f".format(server.ipaddr)
	run_cmd(server, "hostname suma-server.example.com",  "change hostname ", 8000)
	run_cmd(server, "sed -i '$ d' /etc/hosts;", "change hosts file", 100)
	run_cmd(server, change_hostname, "change hostsfile",  200)
	run_cmd(server, "mv  /var/lib/slenkins/tests-suse-manager/tests-server/install/ /", "move install", 900)

######################
# MAIN 
#####################
setup()
SET_SUMAPWD =  "chpasswd <<< \"root:linux\""
SERVER_INIT= "/var/lib/slenkins/tests-suse-manager/tests-server/bin/suma_init.sh"

run_cucumber_on_jail = "cp -R /var/lib/slenkins/tests-suse-manager/tests-control/cucumber/ $WORKSPACE; export CLIENT={}; export TESTHOST={}; export BROWSER=phantomjs; cd $WORKSPACE/cucumber; rake".format(client.ipaddr_ext, server.ipaddr_ext)

def run_all_feature():
	''' this function is on the control-node, and run all cucumber features defined on run_sets/testsuite.yml'''
	journal.beginTest("running cucumber whole suite")
	subprocess.call("cp -R /var/lib/slenkins/tests-suse-manager/tests-control/cucumber/ $WORKSPACE; cd $WORKSPACE/cucumber;", shell=True)
        subprocess.call("export CLIENT={0}; export TESTHOST={1}; export BROWSER=phantomjs; cd $WORKSPACE/cucumber ; rake ".format(client.ipaddr_ext, server.ipaddr_ext), shell=True)
	journal.success("finished to run cucumber")
	
def post_install_server():
	'''' clobberd configuration changes are necessary'''
	# modify clobberd
	journal.beginTest("Set up clobberd right configuraiton")
	replace_clobber = {'redhat_management_permissive: 0' : 'redhat_management_permissive: 1' }
	replace_string(server, replace_clobber, "/etc/cobbler/settings")
	journal.success("done clobberd conf !")
	run_cmd(server, "systemctl restart cobblerd.service && systemctl status cobblerd.service", "restarting cobllerd after configuration changes") 
	# files needed for tests 
	#FIXME this should be done on the packaging side, instead of here :)
	runOrRaise(server, "mv  /var/lib/slenkins/tests-suse-manager/tests-server/pub/* /srv/www/htdocs/pub/", "move to pub", 900)
	runOrRaise(server, "mv  /var/lib/slenkins/tests-suse-manager/tests-server/vCenter.json /tmp/", "move to pub", 900)

def check_cucumber():
    journal.beginTest("check tests cucumber for failures")
    output_cucumber = "$WORKSPACE/cucumber/output.html"
    check = "grep \"scenarios (0 failed\" {}".format(output_cucumber)
    if subprocess.call(check, shell=True) : 
		journal.failure("FAIL : some tests of cucumber failed ! ")
		return False
    journal.success("all tests of cucumber are ok")
    return True


###################################### MAIN ################################################################################
try:
    # change hostname, and move the install(fedora kernel, etc) dir to /
    setup_server()
    # change password to linux to all systems
    [  run_cmd(node, SET_SUMAPWD, "change root pwd to linux") for node in (server, client, minion) ]
    # install some spacewalk packages on client
    client_setup()
    # run migration.sh script
    journal.beginGroup("init suma-machines")
    runOrRaise(server, SERVER_INIT,  "INIT_SERVER", 8000)
    # modify clobber 
    post_install_server()
    # run cucumber suite 
    journal.beginGroup("running cucumber-suite on jail")
    run_all_feature() 
    # check that all test are sucessufull (control node side)
    check_cucumber()

except susetest.SlenkinsError as e:
    journal.writeReport()
    sys.exit(e.code)

except:
    print "Unexpected error"
    journal.info(traceback.format_exc(None))
    raise

susetest.finish(journal)
