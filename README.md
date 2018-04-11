Open Source G2 DSTAR Reflectors(XRF reflectors)
==============================================
Licensed under GPLv3. Please see LICENSE.md for licensing information.

dxrfd is the software to use to create a D-Star reflector. It will run on any Linux box.
It communicates with dstar Gateways/repeaters and it also communicates with dvap,dvtool,... users.

These instructions are based on using Dxrfd 3.08a, which includes additions from Bob/W6KD to secure the command port used to communicate with netcat.

This version also allows clients using a random local port to connect, and will maintain that connection with the heartbeat function. This allows users to
either modify their clients used to connect to the reflector to use random local ports, or some users behind certain types of NAT firewalls. This is useful
when you have another service that connects to the reflector that would normally use the same local port the reflector binds to running on the same server.
This modification was made by Colby Ross, W1BSB.

Add udp ports 30001-30007 & 30010 to your router/firewall.
Add udp ports 20001-20007 to your router/firewall.

Note: You can NOT run both the Reflector and the G2 linking software on the same Linux box.
That is true for all dstar networks and dstar gateways.
The reflector must run on a different box.
(While I haven't actually verified this, the same change that allows random local ports to be used would likely allow the linking software to connect
to it on the same box, if it were indeed using a random local port. This has been tested with the smart-group-server package using a random loocal port, and it links
and connects fine.)

BUILDING dxrfd
==============
All instructions are to be executed as user ID root.
We will assume that the installation is on a Debian Linux box and that a web server is available, preferably on the same machine.

1)
Program should be cloned into /opt. You may also use another location, but be sure to update dxrfd.cfg with the new locations.

	cd /opt
	git clone https://github.com/w1bsb/dxrfd.git

2)
Install/update the libdb-dev package by executing the command, as well as the compiler:  

     apt-get install libdb-dev build-essential gcc

3)
Go to the /opt/dxrfd directory and change the password between the quotes in the passwd.h file.  The password must be between 4-6 characters.

4)
In the /opt/dxrfd directory execute the following commands:

	chmod +x *.doit
	chmod +x *.sh
	./dxrfd.doit

You should have the binary program dxrfd at this point.

SETUP 
=====
To setup the Dstar reflector, edit /usr/local/etc/dxrfd/dxrfd.cfg configuration file.
Set the OWNER value. The OWNER value is the callsign of the DSTAR Reflector.
It must start with the letters XRF and followed by 3 digits which identify the
Reflector number.

Set the ADMIN value to be your personal callsign.  Set values of MAX_USERS and MAX_OTHER_USERS consistent with the server capacity.

Set the command port by verifying or editing: COMMAND_PORT = 30010

Type ./install.sh to install the binary and services to your system. This will install the binary in /usr/local/sbin along with the services
to handle automatic startup and shutdown. The main service file is installed in /usr/local/sbin as xrfd.service, and a systemd timer and systemd service
in /lib/systemd/system.

The install script will tell you how to enable the timer and start the service. 

The log file is /var/log/dxrfd.log

You may uninstall the installed files by issuing ./uninstall.sh. This will remove all services and the binary installed in /usr/local/sbin.

CONTROLLING dxrfd using shell commands
==============================================================
dxrfd server software can be controlled from the shell using netcat(nc) commands on Linux

In dxrfd.cfg there is a COMMAND_PORT that is used to gain access to either software.

The default COMMAND_PORT for dxrfd is COMMAND_PORT=30010 as listed in dxrfd.cfg

The following commands can be sent to dxrfd from within netcat(nc) for Linux.

First start netcat with:
	nc -u  127.0.0.1  30010

If netcat is not already installed, install it by typing apt-get install netcat-traditional

The pl and pu commands will run without a password since they just show status.  All other dxrfd commands require the cmd processor to be in the unlocked state to function.  To unlock the command port for commands, enter the command "ul passwd" subbing in your password for "passwd", as set in the passed.h file.  You will get a $ prompt which tells you the cmd interpreter is unlocked.  Then enter commands as before.  The program will automatically re-lock the cmd processor one minute after receiving the last valid command, or if you give it the explicit command "lk".  A response of "TIMEOUT" means you have waited too long since the last valid command and the processor was automatically re-locked...just enter the "ul passwd" command to unlock it again.

You will not get a prompt with netcat when locked and a $ prompt when unlocked.  Ctrl-c exits netcat.

Then you can issue any of the following commands:

pu                   "print users"
mu                   "mute users"
uu                   "unmute users"
pl                   "print links"
sh                   "shut it down"
pb                   "print blocked callsigns"
ab KI4LKF            "add a block on KI4LKF"
rb KI4LKF            "remove the block on KI4LKF"
mc KI4LKF            "mute the callsign KI4LKF"
uc KI4LKF            "unmute the callsign KI4LKF"
qsoy                 "qso details set to YES"
qson                 "qso details set to NO"
pv                   "print the current software version"
lrf AXRF727A         "link your module A (first A) to XRF727 module A (second A)"
lrf AXRF727X         "unlink your module A from XRF727"
upd                  "update the reflector after changes were made to the blocks.txt and xrfs.txt files"

For the link to another reflector to be successful, your xrfs.txt file must contain a reference to that reflector, and the other reflector's xrfs.txt file must contain a reference to your reflector. After making changes to the file, issue the upd command. 

To block a callsign add it to the blocks.txt file, or remove it to unblock.  After making changes to the file, issue the upd command. The ab and rb commands allow a temporary block to be added or removed without having edit blocks.txt and issuing the upd command. These nc commands take precedence over the blocks.txt file for the specific callsigns involved.

To completely block or unblock a callsign, it is necessary to include the callsign with each terminal suffix registered.  The format is identical between the nc commands, ab and rb, and the blocks.txt file.  The callsign can either be by itself or with a terminal.  Actual underscores (_) are used between the callsign and the terminal, which must be in the 8th position.  The callsigns and terminals registered can be found at:

http://query.ke5bms.com/index.php
https://wb1gof.dstargateway.org/cgi-bin/dstar-regcheck
http://dstar.prgm.org/cgi-bin/dstar-regcheck

Here is an example of the output of the command pu

nc -u 127.0.0.1 30010
pu
KJ4NHF  ,1.2.3.4,REPEATER,062909,22:43:23,notMuted

This says that the connected item is a LINKED dstar Repeater and it was linked at 062909,22:43:23  

Netcat can be used to test the reflector prior to getting the dashboard running.

The status file for dxrfd is XRF_STATUS.txt
which lists all the links for the 3 reflector modules if any module is linked.

Making changes to dxrfd.cfg
==============================================================

If changes are made to dxrfd.cfg, the dxrfd service needs to be stopped and started for the changes to take effect.
To stop and restart, enter:

	systemctl restart dxrfd

To check the status, enter:

	systemctl status dxrfd

When the service stops, all linked reflectors, users, and repeaters become unlinked.  The links to other reflectors will need to be reestablished using the lrf command.   Also, the previous contents of the Dashboard Last Heard will be deleted.

DISPLAYING the dstar reflector activity on your web site - creating the dashboard
=================================================================================

1) Edit xrf_lh.cpp

The different xrf_lh.cpp are different dashboard source code files for you to try some of them are generic.  The most generic versions are xrf_lh.cpp_114g and the latest, xrf_lh.cpp-v1.14i.  These versions do not require any editing of the code.  The files contain headers that document the revisions.  Rename the selected file to xrf_lh.cpp and go to step 2.

If using a template that does require modification of the code, in this statement:

fprintf(stderr, "Usage: ./xrf_lh yourPersonalCallsign yourXRFreflector description IPaddressOF_XRF\n");

If yourPersonalCallsign set to '1NFO' (that's ONE N F OH), your personal callsign will not appear in the list of dongle users.  If the web server is on the same machine, IPaddressOF_XRF should be 127.0.0.1

2) Make file xrf_lh executable by typing  chmod +x xrf_lh.doit 

3) Compile the .cpp file by typing ./xrf_lh.doit

4) Edit dashboard_xrf

Edit the following line in the script as described above:
./xrf_lh 1NFO XRFnnn "XRFnnn" 127.0.0.1 > status.html

Edit the path in the following lines to indicate the webserver default directory.  This is the directory where index.html is generally found.  Depending on the installation, it could be 
/var/www/html   or
/etc/httpd/htdocs/

5) Create a subdirectory g2_ircddb under the webserver default directory.  Copy files mm_training.css and mm_spacer.gif to this subdirectory.

6) Run the script by typing ./dashboard_xrf
That will generate the index file for the dashboard.  It uses xrf_lh program to talk to the gateway and get the last heard info and who is connected.

7) Set up a cron job to run the dashboard_xrf script to update the dashboard page.  To do this at 1 minute intervals.  Find file named root located in directory /var/spool/cron.  Enter the following line:

0-59/1 * * * * /root/dxrfd/dashboard_xrf > /dev/null 2>&1

Ensure there is exactly one space between the 1 and the first *, between each *, and between the final * and the /

Creating a cron job to link to reflectors
===================================================================================

To check the linking status and if unlinked, then relink to from Module A to XRF123 Module A and from Module B to XRF456 Module B every 15 minutes, create a line in file named root located in directory /var/spool/cron:

0-59/15 * * * * /root/dxrfd/samplelink.sh > /dev/null 2>&1

File samplelink.sh has these contents:
#####################################################
#!/bin/bash

echo "ul passwd" | nc -u -w 1 127.0.0.1 30010 >/dev/null
echo "lrf AXRF123A" | nc -u -w 1 127.0.0.1 30010 >/dev/null
echo "lrf BXRF456B" | nc -u -w 1 127.0.0.1 30010 >/dev/null
echo "lk" | nc -u -w 1 127.0.0.1 30010 >/dev/null
nc -u -w 1 127.0.0.1 30010 <<EOF >/dev/null

exit 0

#####################################################


