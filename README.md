Welcome to use [PyDeployTool](https://github.com/fyears/PyDeployTool), a python apps deployment toolkit.

It's not quite easy to deploy python apps for freshmen in production. This toolkit would help.

**But remember, you are at your own risk if you decide to use this toolkit. The author @fyears is NOT responsible to your choice.** Well, the author are trying his best to avoid bugs, since he or she is using it as well.

[Nginx](http://nginx.org/en/) and [uWSGI](http://projects.unbit.it/uwsgi/wiki) are perfect to deploy python apps.

To install them using this toolkit (you must be a root user or using `sudo`) when you are in the toolkit folder:  
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
* You can onfigure the nginx conf file(s) you want in `/usr/local/nginx/conf`  
* You can onfigure the uWSGI params with files, if you put all your uwsgi files in `/home/pyconf/uwsgiconf`. (`uwsgi --emperor /home/pyconf/uwsgiconf --emperor-tyrant` will run on system boot.)  
* Every `/home/wwwroot/$domain/pyenv` created by `./vhost4py.sh` is a python virtualenv.  
* You can asily upgrade nginx with `./upgrade_nginx.sh`.  
* You can easily upgrade uWSGI because it's installd by running `sudo pip install uwsgi`  

This toolkit is compatible with and modified another amazing toolkit: [LNMP](http://lnmp.org). In fact, you can just run `./install_uwsgi.sh` after installing that toolkit. So your VPS or your server can run python apps and php apps. Many files in this toolkit are directly taken from [LNMP package](http://soft.vpser.net/lnmp/lnmp0.8.tar.gz), some are modifed, and some are created by @fyears with the help of Internet.


For more information, visit:  
* [Nginx](http://nginx.org/en/)  
* [uWSGI](http://projects.unbit.it/uwsgi/wiki)  
* [LNMP](http://lnmp.org)  
* [python apps deployment toolkit](https://github.com/fyears/PyDeployToolkit)  

To find the author of this python apps deployment toolkit:  
* [Fleeting Years // 流年](http://www.fyears.org/)  
* [@fyears](http://twitter.com/fyears)  

"Fork it" and "send pull request" are warmly welcome.