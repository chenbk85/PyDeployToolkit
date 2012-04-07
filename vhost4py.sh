#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, use sudo sh $0"
    exit 1
fi

clear
echo "========================================================================="
echo "Add Virtual Host"
echo "========================================================================="

if [ "$1" != "--help" ]; then


	domain="www.lnmp.org"
	echo "Please input domain:"
	read -p "(Default domain: www.lnmp.org):" domain
	if [ "$domain" = "" ]; then
		domain="www.lnmp.org"
	fi
	if [ ! -f "/usr/local/nginx/conf/vhost/$domain.conf" ]; then
	echo "==========================="
	echo "domain=$domain"
	echo "===========================" 
	else
	echo "==========================="
	echo "$domain is exist!"
	echo "==========================="	
	fi
	
	echo "Do you want to add more domain name? (y/n)"
	read add_more_domainame
	if [ "$add_more_domainame" == 'y' ]; then
	  echo "Type domainname,example(bbs.vpser.net forums.vpser.net luntan.vpser.net):"
	  read moredomain
          echo "==========================="
          echo domain list="$moredomain"
          echo "==========================="
	  moredomainame=" $moredomain"
	fi

	vhostdir="/home/wwwroot/$domain"
	echo "==========================="
	echo Virtual Host Directory="$vhostdir"
	echo "==========================="

	echo "==========================="
	echo "Allow Rewrite rule? (y/n)"
	echo "==========================="
	read allow_rewrite

	if [ "$allow_rewrite" == 'n' ]; then
		rewrite="none"
	else
		rewrite="other"
	fi
	echo "==========================="
	echo You choose rewrite="$rewrite"
	echo "==========================="

	echo "==========================="
	echo "Allow access_log? (y/n)"
	echo "==========================="
	read access_log
	if [ "$access_log" == 'n' ]; then
	  al="access_log off;"
	else
	  echo "Type access_log name(Default access log file:$domain.log):"
	  read al_name
	  if [ "$al_name" = "" ]; then
		al_name="$domain"
	  fi
	  al="log_format  $al_name  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
             '\$status \$body_bytes_sent "\$http_referer" '
             '"\$http_user_agent" \$http_x_forwarded_for';
		access_log  /home/wwwlogs/$al_name.log  $al_name;"
	echo "==========================="
	echo You access log file="$al_name.log"
	echo "==========================="
	fi

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
	echo "Press any key to start create virtul host..."
	char=`get_char`


if [ ! -d /usr/local/nginx/conf/vhost ]; then
	mkdir /usr/local/nginx/conf/vhost
fi

echo "Create Virtul Host directory......"
mkdir -p $vhostdir
touch /home/wwwlogs/$al_name.log
echo "set permissions of Virtual Host directory......"
chmod -R 755 $vhostdir
chown -R www:www $vhostdir

if [ ! -f /usr/local/nginx/conf/$rewrite.conf ]; then
  echo "Create Virtul Host ReWrite file......"
	touch /usr/local/nginx/conf/$rewrite.conf
	echo "Create rewirte file successful,now you can add rewrite rule into /usr/local/nginx/conf/$rewrite.conf."
else
	echo "You select the exist rewrite rule:/usr/local/nginx/conf/$rewrite.conf"
fi

cat >/usr/local/nginx/conf/vhost/$domain.conf<<eof
server
	{
		listen       80;
		server_name $domain$moredomainame;
		index index.html index.htm index.php default.html default.htm default.php;
		root  $vhostdir;

		include $rewrite.conf;
		
		location / {
			include uwsgi_params;
			uwsgi_pass unix:/tmp/$domain.uwsgi.sock;
			}
		location /static/ {
			alias $vhostdir/static/;
			try_files \$uri @uwsgi;
			}
		
		location @uwsgi {
			include uwsgi_params;
			uwsgi_pass unix:/tmp/$domain.uwsgi.sock;
			}
			
		#location ~ .*\.(php|php5)?$
		#	{
		#		fastcgi_pass  unix:/tmp/php-cgi.sock;
		#		fastcgi_index index.php;
		#		include fcgi.conf;
		#	}

		location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
			{
				expires      30d;
			}

		location ~ .*\.(js|css)?$
			{
				expires      12h;
			}

		$al
	}
eof

virtualenv $vhostdir/pyenv
source $vhostdir/pyenv/bin/activate
pip install Flask
deactivate

cat >$vhostdir/appmainfile.py<<eof
#!/usr/bin/python
# -*- coding: utf-8 -*-
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return 'Hello world from my new Flask python app!'
def application(environ, start_response):
    return app(environ, start_response)
if __name__ == '__main__':
    app.run()
eof

cat >/home/pyconf/uwsgiconf/$domain.uwsgi.ini<<eof
[uwsgi]
; it's recommended to use domain.uwsgi.ini file to configure uWSGI because it's most readable and editable
; it's recommended to run (for example) sudo chown www:www domain.uwsgi.ini after you change the file, though it's not necessary if you've set chmod-socket
socket = /tmp/$domain.uwsgi.sock
; using socket instead of tcp is recommended
master = 1 
threads = 40
processes = 4
virtualenv = $vhostdir/pyenv
; the path to the virtualenv
chdir = /home/wwwroot/$domain
; the folder of your app
module = appmainfile
; the name of the main file or entrance for uwsgi of your app without .py
callable = app
; it's for Flask app
chmod-socket = 666
; you should always set this if you use socket, otherwise nginx can't connect the socket (unless you set uid & gid to www)
uid = www
; you should always set this if you use socket, though it's not necessarily required if you've set chmod-socket
sid = www
; you should always set this if you use socket, though it's not necessarily required if you've set chmod-socket
limit-as 256
; it's recommended to set a limit memory usage
eof
chown www:www /home/pyconf/uwsgiconf/$domain.uwsgi.ini

echo "Test Nginx configure file......"
/usr/local/nginx/sbin/nginx -t
echo ""
echo "Restart Nginx......"
/usr/local/nginx/sbin/nginx -s reload

echo "========================================================================="
echo "Virtual Host for python apps created."
echo "========================================================================="
echo ""
echo "Your domain:$domain"
echo "Directory of $domain:$vhostdir"
echo "Your uwsgi congifure file:/home/pyconf/uwsgiconf/$domain.uwsgi.ini"
echo "The python virtual environment of $domain:$vhostdir/pyenv"
echo "For more infomation, visit http://www.fyears.org/"
echo ""
echo "========================================================================="
fi
