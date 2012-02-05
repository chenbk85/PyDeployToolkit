#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, use sudo sh $0"
    exit 1
fi

clear

echo ""
echo "Please backup your nginx data!!!!!"

	get_char()
	{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
	}
	echo ""
	echo "Press any key to start uninstall nginx and uwsgi , please wait ......"
	char=`get_char`

killall nginx

rm -rf /usr/local/nginx
rm /root/vhost4py.sh
rm /root/lnmp

echo "Nginx + uwsgi Uninstall completed."

echo "========================================================================="
echo ""
echo "For more information please visit http://www.lnmp.org/ and http://www.fyears.org/"
echo ""
echo "========================================================================="