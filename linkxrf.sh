#####################################################
#!/bin/bash

echo "ul passwd" | nc -u -w 1 127.0.0.1 30010 >/dev/null
echo "lrf AXRF123A" | nc -u -w 1 127.0.0.1 30010 >/dev/null
echo "lrf BXRF456B" | nc -u -w 1 127.0.0.1 30010 >/dev/null
echo "lk" | nc -u -w 1 127.0.0.1 30010 >/dev/null
nc -u -w 1 127.0.0.1 30010 <<EOF >/dev/null

exit 0

#####################################################}