#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

# Check if nginx has been installed
if [ -s /usr/local/nginx ]; then
  echo "/usr/local/nginx [found]"
  else
  echo "Error: /usr/local/nginx not found!!! You should run ./install_nginx.sh first."
  exit 1
fi

clear
echo "========================================================================="
echo "Uwsgi installation bash for Ubuntu VPS ,  Written by @fyears "
echo "========================================================================="
echo "A tool to auto-compile & install uwsgi on Linux "
#echo ""
#echo "For more information please visit http://www.fyears.org/"
echo "========================================================================="
cur_dir=$(pwd)

if [ "$1" != "--help" ]; then


#set main domain name

	domain="www.lnmp.org"
	echo "Please input domain:"
	read -p "(Default domain: www.lnmp.org):" domain
	if [ "$domain" = "" ]; then
		domain="www.lnmp.org"
	fi
	echo "==========================="
	echo "domain=$domain"
	echo "==========================="

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
	echo "Press any key to start..."
	char=`get_char`

apt-get update

apt-get update
apt-get autoremove -y

apt-get install -y build-essential psmisc python-dev libxml2 libxml2-dev python-setuptools python-pip

echo "========================== uwsgi install ==============================="
#groupadd www
#useradd -s /sbin/nologin -g www www
pip install uwsgi
pip install virtualenv

mkdir -p /home/pyconf/uwsgiconf
chown -R www:www /home/pyconf/uwsgiconf

echo "==================== uwsgi install completed ==========================="
cd $cur_dir
cp conf/index.html /home/wwwroot/index.html

#start up
cd $cur_dir
cp conf/init.uwsgi /etc/init/uwsgi_emperor.conf

cd $cur_dir
cp vhost4py.sh /root/vhost4py.sh
chmod +x /root/vhost4py.sh

start uwsgi_emperor
/etc/init.d/nginx restart

echo "========================== Check install ================================"

echo "Install uwsgi completed! enjoy it."
echo "========================================================================="
echo "Uwsgi installation bash for Ubuntu VPS ,  Written by @fyears "
echo "========================================================================="
echo ""
echo "For more information please visit http://www.fyears.org/"
echo ""
echo "The path of some dirs:"
echo "nginx conf files dir:   /usr/local/nginx/conf"
echo "uwsgi conf files dir:   /home/pyconf/uwsgiconf"
echo "web dir :     /home/wwwroot"
echo "hints:"
echo "manage nginx: /etc/init.d/nginx {start|stop|reload|restart|kill}"
echo "manage uwsgi: {start|stop|reload|restart|kill} uwsgi_emperor"
echo "Every time you change the uwsgi conf files, it should be reloaded automatically."
echo "Every time you change the nginx conf files or python project files, you have to reload or restart nginx and uwsgi_emperor by hands."
echo ""
echo "========================================================================="

fi