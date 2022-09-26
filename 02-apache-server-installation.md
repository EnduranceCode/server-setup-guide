# Server setup guide

## Introduction

This file contains the **[Apache Server installation](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04)** section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

## Table of Contents

2. [Apache Server installation](#2-apache-server-installation)
    1. [Install Apache](#21-install-apache)
    2. [Setup the firewall](#22-setup-the-firewall)
    3. [Check the Apache Server](#23-check-the-apache-server)
    4. [Change the Apache Server web root folder](#24-change-the-apache-server-web-root-folder)
    5. [Setup the default directory to be served by Apache Web Server](#25-setup-the-default-directory-to-be-served-by-apache-web-server)
    6. [2.6. Set permissions for the Apache Server root folder](#26-set-permissions-for-the-apache-server-root-folder)
    7. [Keep the Apache Server root folder access permissions consistent with a cron job](#27-keep-the-apache-server-root-folder-access-permissions-consistent-with-a-cron-job)

## 2. Apache Server installation

### 2.1. Install Apache

[Install](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04#step-1-installing-apache) the [**Apache Server**](https://httpd.apache.org/) with the following commands:

    sudo apt update && sudo apt install apache2

To confirm that the installation was successful and to get the installed **Apache Server** version, execute the following command:

    apache2 -v

### 2.2. Setup the firewall

List the [*ufw*](https://launchpad.net/ufw) application profiles wit the following command:

    sudo ufw app list

Check the firewall status with the following command:

    sudo ufw status

Enable the *ufw* profile that opens both port 80 (normal, unencrypted web traffic) and port 443 (TLS/SSL encrypted traffic) with the following command:

    sudo ufw allow 'Apache Full'

Check again the firewall status with the following command:

    sudo ufw status

### 2.3. Check the Apache Server

[Check](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04#step-3-checking-your-web-server) if the **Apache Server** service is active with the following command:

    sudo systemctl status apache2.service -l --no-pager

If the **Apache AH00558 configuration error** is shown, it's necessary to edit the configuration file `/etc/apache2/apache2.conf`. Open the file with the following command:

    sudo nano /etc/apache2/apache2.conf

Within this file, use the command `CTRL + W` to search for the directive *ServerName*. If it isn't present, as instructed on [this Digital Ocean Tutorial](https://www.digitalocean.com/community/tutorials/apache-configuration-error-ah00558-could-not-reliably-determine-the-server-s-fully-qualified-domain-name), add to the bottom of the file the following snippet:

    # Fix the Apache AH00558 configuration error
    ServerName localhost

Save the changes with the command `CTRL + O` and then exit the [nano text editor](https://www.nano-editor.org/) with the command `CTRL + X`.

After making the above mentioned modifications in the **Apache Server** configuration, validate it with the following command:

    sudo apachectl configtest

If everything is correct, make the changes effective, running the following command:

    sudo systemctl restart apache2

[Check](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04#step-3-checking-your-web-server) if the **Apache Server** service is active with the following command:

    sudo systemctl status apache2.service -l --no-pager

To check if Apache Server is running correctly, replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

    http://{SERVER_IP_ADDRESS}/

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

### 2.4. Change the Apache Server web root folder

By default, the **Apache Server** root folder (where the [Virtual Hosts](http://httpd.apache.org/docs/current/vhosts/) are stored) is the folder `/var/www/` but I prefer to use the folder `/srv/www/` instead. To create this folder, execute the following commands:

    sudo mkdir /srv/www

Check the output of the below command to verify that the folder was properly created.

    ls --group-directories-first -la /srv/

The file `/etc/apache2/apache2.conf` must be edited to allow the **Apache Server** to access the folder `/srv/www/`. Use the [*nano text editor*](https://www.nano-editor.org/) to edit the file `apache2.conf` with the following command:

    sudo nano /etc/apache2/apache2.conf

Within the file, use the command `CTRL + W` to search for the **\<Directory** directives and comment out the `/var/www/` folder directive. When finished, it must look like the below snippet.

    #<Directory /var/www/>
    #   Options Indexes FollowSymLinks
    #   AllowOverride None
    #   Require all granted
    #</Directory>

And then add the following directive:

    <Directory /srv/www/>
      Options Indexes FollowSymLinks
      AllowOverride All
      Require all granted
    </Directory>

In the above directive, *AllowOverride* is set to ***All*** to allow `.htaccess` files in the virtual hosts.

Still within the file `/etc/apache2/apache2.conf`, add the bellow snippet immediately after the `ServerName` directive.

    # Configure the DocumentRoot directive
    DocumentRoot /srv/www

After introducing all the changes, save the file with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`.

Validate the **Apache Server** configuration with the following command:

    sudo apachectl configtest

If everything is correct, make the changes effective, running the following command:

    sudo systemctl restart apache2

[Check](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04#step-3-checking-your-web-server) if the **Apache Server** service is active with the following commands:

    sudo systemctl status apache2.service -l --no-pager
    apachectl -S

### 2.5. Setup the default directory to be served by Apache Web Server

The directory `/srv/www` will be used as parent directory of all Virtual Hosts on the server, but the directory `/var/www/html` will be moved to `/srv/www/` to serve as the default directory that is served if a client request doesn’t match any other sites.

Disable the **Apache Server** default Virtual Host, with the following commands:

    sudo a2dissite 000-default.conf
    sudo systemctl restart apache2

Copy the content of the **Apache Server** default server block to the folder `/srv/www` with the following command:

    sudo rsync -av /var/www/html /srv/www

To backup the default Virtual Host configuration file, execute the following command:

    sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.original

Start editing the **Apache Server** default Virtual Host configuration file with the following command:

    sudo nano /etc/apache2/sites-available/000-default.conf

Replace the ***{LABEL}*** in the below snippet as appropriate and use it to replace the existing directives in the default Virtual Host configuration file.

    ServerAdmin {SERVER_ADMIN_EMAIL}
    DocumentRoot /srv/www/html

> **Label Definition**
>
> + **{SERVER_ADMIN_EMAIL}** : The server's admin e-mail

After introducing all the changes, save the file with the command `CTRL + O` and then exit the [nano text editor](https://www.nano-editor.org/) with the command `CTRL + X`.

Validate the **Apache Server** configuration with the following command:

    sudo apachectl configtest

Enable the default  Virtual Host configuration file with the following commands:

    sudo a2ensite 000-default.conf
    sudo systemctl restart apache2

[Check](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04#step-3-checking-your-web-server) if the **Apache Server** service is active with the following command:

    sudo systemctl status apache2.service -l --no-pager

To check if Apache Server running correctly, replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

### 2.6. Set permissions for the Apache Server root folder

The default **owner** and **group** of **Apache Server** root folder is `root:root` and that is fine if the server is only serving static content. But, if server is intended to serve dynamic content, this needs to be changed. There's no absolute right way to set this configurations but [this answer](https://serverfault.com/a/357109) on [ServerFault](https://serverfault.com/) and [this other answer](https://superuser.com/a/19333) on [SuperUser](https://superuser.com/) were taken in consideration to set my own configuration.

A good solution for this problem is to use the **Apache Server** **user** and **group** as the owner and group of the server web root folder. On *Ubuntu*, the **Apache Server** **user** and **group** is `www-data`. Check the output of the below command to get the **user** and **group** of the **Apache Server**.

    apachectl -S

### 2.6.1. Standard permissions for the Apache Server root folder

Assuming that `www-data` is indeed the **user** that runs **Apache Server**, set the [file permissions](https://linuxize.com/post/umask-command-in-linux/) for the server root folder with the following commands:

    sudo chown -R www-data:www-data /srv/www
    sudo find /srv/www -type d -exec chmod -c 2770 {} +
    sudo find /srv/www -type f -exec chmod -c 660 {} +

The `ùmask` has to be set accordingly the permissions level set with above command, therefore it must be set to `007`. To check the current `umask`value, execute the following command:

    umask

To [permanently set the `umask` value](https://linuxize.com/post/umask-command-in-linux/#setting-the-mask-value) system-wide, open the `/etc/profile` file with [*nano text editor](https://www.nano-editor.org/) using the following command:

    sudo nano /etc/profile

Within `/etc/profile` file, add the below snippet at the beginning of the file.

    umask 007

To make the modifications effective, execute the following commands:

    source /etc/profile
    source ~/.bashrc

To verify if the new settings are working as intended, execute the below commands to create a new file and a new directory and then check its listed permissions.

    mkdir /tmp/newfolder
    touch /tmp/newfile
    ls --group-directories-first -la /tmp

To give a user writing permissions on the **Apache Server** root folder it's now necessary to add him to the `www-data` group. Do that, replacing the ***{LABEL}*** in the below command as appropriate and then execute it.

    sudo usermod -aG www-data {USER}

> **Label Definition**
>
> + **{USER}** : The user account to be added to the `www-data` group

As explained in [this answer](https://unix.stackexchange.com/a/11573) on [StackExchange](https://unix.stackexchange.com/), changes to the user's group membership only takes effect when the user logs in. So the user needs to log out and log back in to make these modifications effective. If it is really necessary to force the previous group assignment to take effect without logging out, use the trick explained on [this answer](https://superuser.com/a/345051) on [StackExchange](https://superuser.com/) and execute the below commands. Otherwise, just logout the server and log back in.

    newgrp www-data
    newgrp $USER

### 2.6.2. Restricted permissions for the Apache Server root folder

In a more restrictive scenario, the **Apache Server** server should [only have writing permissions](https://www.internalpointers.com/post/right-folder-permission-website) on the folders where it is strictly necessary. On those scenarios, set the [file permissions](https://linuxize.com/post/umask-command-in-linux/) for the server root folder with the following commands:

    sudo chown -R root:www-data /srv/www
    sudo find /srv/www -type d -exec chmod -c 2750 {} +
    sudo find /srv/www -type f -exec chmod -c 650 {} +

For the folders that must be writable by the **Apache Server**, replace the ***{LABELS}*** in the below commands as appropriate and execute it for each folder that has to be writable by the **Apache Server**

    sudo find /srv/www/{WRITABLE_FOLDER} -type d -exec chmod -c 2750 {} +
    sudo find /srv/www/{WRITABLE_FOLDER} -type f -exec chmod -c 650 {} +

> **Labels Definition**
>
> + **{WRITABLE_FOLDER}** : The folder that must be writable by the **Apache Server**

The `ùmask` has to be set accordingly the permissions level set with above command, therefore it must be set to `027`. To check the current `umask`value, execute the following command:

    umask

To [permanently set the `umask` value](https://linuxize.com/post/umask-command-in-linux/#setting-the-mask-value) system-wide, open the `/etc/profile` file with [*nano text editor](https://www.nano-editor.org/) using the following command:

    sudo nano /etc/profile

Within `/etc/profile` file, add the below snippet at the beginning of the file.

    umask 027

For the changes to take effect, execute the following commands:

    source /etc/profile
    source ~/.bashrc

To verify if the new settings are working as intended, execute the below commands to create a new file and a new directory and then check its listed permissions.

    mkdir /tmp/newfolder
    touch /tmp/newfile
    ls --group-directories-first -la /tmp

### 2.7. Keep the Apache Server root folder access permissions consistent with a cron job

Over the time, there will be some inconsistencies on the permissions of the **Apache Server** root folder. On the folder `system/usr/local/bin` of this repository there are two scripts ([fixApacheWebRootPermissions.sh](system/usr/local/bin/ffixApacheWebRootPermissions.sh) and [cronJobFixApacheWebRootPermissions.sh](system/usr/local/bin/cronJobFixApacheWebRootPermissions.sh)) that resets the chosen permissions on the **Apache Server** root folder. To [download and make these scripts executable and available on the system](https://help.ubuntu.com/community/HowToAddaLauncher) start by downloading it to the `/usr/local/bin` folder with the following commands:

    sudo wget -P /usr/local/bin/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/usr/local/bin/fixApacheWebRootPermissions.sh
    sudo wget -P /usr/local/bin/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/usr/local/bin/cronJobFixApacheWebRootPermissions.sh

To check if the files were properly copied, check the output of the following command:

    ls --group-directories-first -la /usr/local/bin/

The file `/usr/local/bin/fixApacheWebRootPermissions.sh` might need some modifications to ensure its compatibility with the server's system. Use the below command to open the file `fixApacheWebRootPermissions.sh` with the [*nano text editor*](https://www.nano-editor.org/).

    sudo nano /usr/local/bin/fixApacheWebRootPermissions.sh

Check if the script is correct, make all the needed (if any) modifications and then save the file with the command `CTRL + O` and exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`.

Repeat the previous process for the file `/usr/local/bin/cronJobFixApacheWebRootPermissions.sh` with the following command:

    sudo nano /usr/local/bin/cronJobFixApacheWebRootPermissions.sh

Make these scripts executable with the following commands:

    sudo chmod +x /usr/local/bin/fixApacheWebRootPermissions.sh
    sudo chmod +x /usr/local/bin/cronJobFixApacheWebRootPermissions.sh

Check the output of the below command to confirm that the files were properly made executable.

    ls --group-directories-first -la /usr/local/bin/

If everything was properly set, both scripts are available to be executed from anywhere in the system.

With these two scripts made executable, it's time to create a [cronjob](https://www.cyberciti.biz/faq/define-cron-crond-and-cron-jobs/) to automate the execution of the script ([cronJobFixApacheWebRootPermissions.sh](system/usr/local/bin/cronJobFixApacheWebRootPermissions.sh)) everyday at 3:00. Edit the root's *crontab* with the following command:

    sudo crontab -e

The above command will open a text editor in the terminal. Append the below snippet to the file opened with the previous command.

    #
    #
    # Daily fix of the Apache's root folder permissions
    0 3 * * * /usr/local/bin/cronJobFixApacheWebRootPermissions.sh

After checking that the added commands are correct and well suited for the system, save and close the file. To list the cron jobs created, execute the following command:

    sudo crontab -l
