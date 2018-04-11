#!/bin/bash

if [ "$EUID" != 0 ]
  then echo "You must be root to execute this program."
  exit
fi

if [ ! -f /opt/dxrfd/dxrfd ]; then
    echo "dxrfd not found. Please compile it first with /opt/dxrfd/dxrfd.doit"
    exit
fi
		mkdir -p /usr/local/etc/dxrfd/
		echo -e "Installing dxrfd and xrfd.service to /usr/local/sbin..."
		cp -f dxrfd /usr/local/sbin/
		cp -f xrfd.service /usr/local/sbin/
		echo -e "Done."
		echo -e "Installing dxrfd.cfg and xrfs.txt to /usr/local/etc/dxrfd..."
		cp -u dxrfd.cfg /usr/local/etc/dxrfd
		cp -u xrfs.txt /usr/local/etc/dxrfd
		cp -u blocks.txt /usr/local/etc/dxrfd
		echo -e "Done."
		echo -e "Installing dxrfd.timer and dxrfd.service into /lib/systemd/system..."
		cp -f dxrfd.timer /lib/systemd/system/
		cp -f dxrfd.service /lib/systemd/system/
		systemctl daemon-reload

		echo -e "You can now enable the timer with systemctl enable dxrfd.timer, and systemctl start dxrfd.timer."
		echo -e "The service should start automatically after 60 seconds, and 60 seconds after each boot."
		echo -e "If for some reason the service doesn't start automatically, you may issue systemctl start dxrfd to start the service."
		echo -e "You may stop the service with systemctl stop dxrfd, restart with systemctl restart dxrfd, and get status with"
		echo -e "systemctl status dxrfd."
exit
