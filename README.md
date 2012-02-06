Welcome to use [PyDeployTool](https://github.com/fyears/PyDeployTool), a python apps deployment toolkit.

It's not quite easy to deploy python apps for freshmen in production. This toolkit would help.

**But remember, you are at your own risk if you decide to use this toolkit. The author @fyears is NOT responsible to your choice.** Well, the author are trying the best to avoid bugs, since he or she is using it as well. :-)

**Now, this toolkit is for ubuntu only! Though you may use it in other

[Nginx](http://nginx.org/en/) and [uWSGI](http://projects.unbit.it/uwsgi/wiki) are perfect to deploy python apps.

To install them using this toolkit (you must be a root user or using `sudo`) when you are in the toolkit folder: 
`git clone git@github.com:fyears/PyDeployToolkit.git`  
`cd PyDeployToolkit/`   
`./install_nginx.sh`   
`./install_uwsgi.sh`  
You must install nginx before uWSGI.

When you want to add a virtualhost (you must be a root user or using `sudo`):  
`cd /root`  
`./vhost4py.sh`  

The toolkit will do the following things:  
* Install nginx and add the init file  
* Install uWSGI and add the init file  
* Simplify the steps to add a new virtualhost  

With the help of the toolkit, :  
* You can configure the nginx conf file(s) you want in `/usr/local/nginx/conf`  
* You can configure the uWSGI params with files, if you put all your uwsgi files in `/home/pyconf/uwsgiconf/`. (`uwsgi --emperor /home/pyconf/uwsgiconf --emperor-tyrant` will run on system boot.)  If you use socket, you should always set `uid = www` and `gid = www`, and it's strongly recommended to run (for example) `sudo chown www:www yourdomainconf.ini` after you modify the file.
* Every `/home/wwwroot/$domain/pyenv` folder created by `./vhost4py.sh` is a python virtualenv.  
* You can easily upgrade nginx with `./upgrade_nginx.sh`.  
* You can easily upgrade uWSGI because it's installd by running `sudo pip install uwsgi`.

You should know:  
* web dir: `/home/wwwroot`  
* to manage nginx: `/etc/init.d/nginx {start|stop|reload|restart|kill}`  
* to manage uwsgi: `{start|stop|reload|restart|kill} uwsgi_emperor`  
* to check nginx file: `/usr/local/nginx/sbin/nginx -t`  
* Every time you change the uwsgi conf files (`/home/pyconf/uwsgiconf/*.{ini|xml|json|...}`), the related python apps should be reloaded automatically.  
* Every time you change the nginx conf files or python project files, you have to reload or restart nginx and uwsgi_emperor by hands.  

This toolkit is compatible with and modified from another amazing toolkit: [LNMP](http://lnmp.org). In fact, you can just run `./install_uwsgi.sh` after installing that toolkit. After that your VPS or your server can run both python apps and php apps. You can add a vhost running in php with `cd /root && sudo ./vhost.sh`. Many files in this toolkit are directly taken from [LNMP package](http://soft.vpser.net/lnmp/lnmp0.8.tar.gz), some are modifed, and some are created by @fyears with the help of Internet.


Websites you may be interested in:  
* [Nginx](http://nginx.org/en/)  
* [uWSGI](http://projects.unbit.it/uwsgi/wiki)  
* [LNMP](http://lnmp.org)  
* [PyDeployToolkit](https://github.com/fyears/PyDeployToolkit)  

To find the author of this python apps deployment toolkit:  
* [Fleeting Years // 流年](http://www.fyears.org/)  
* [@fyears](http://twitter.com/fyears)  

"Fork it" and "send pull request" are warmly welcome.