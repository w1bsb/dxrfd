#!/bin/bash

if [ "$EUID" != 0 ]
  then echo "You must be root to execute this program."
  exit
fi

echo -e "Uninstalling dxrfd and xrfd.service from /usr/local/sbin..."
rm -f /usr/local/sbin/dxrfd
rm -f /usr/local/sbin/xrfd.service
echo "Done."
echo -e "Disabling dxrfd.timer..."
systemctl disable dxrfd.timer
echo "Done."
echo -e "Uninstalling dxrfd.timer and dxrfd.service..."
rm -f /lib/systemd/system/dxrfd.timer
rm -f /lib/systemd/system/dxrfd.service
systemctl daemon-reload
echo -e "Done."
echo -e "Removing /usr/local/etc/dxrfd/..."
rm -rf /usr/local/etc/dxrfd
echo "Done. Uninstall is now complete."
exit

