# Server setup guide

## Introduction

This file contains the **Server management** section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

## Table of Contents

5. [Server management](#5server-management)
    1. [Apache | Create a Virtual Host](#51-apache--create-a-virtual-host)
    2. [Apache | Secure Apache with Let's Encrypt](#52-apache--secure-apache-with-lets-encrypt)
    3. [MySQL | Create a MySQL database](#53-mysql--create-a-mysql-database)
    4. [MySQL | Create a MySQL user](#54-mysql--create-a-mysql-user)
    5. [MySQL | Grant privileges to a MySQL user](#55-mysql--grant-privileges-to-a-mysql-user)
    6. [MySQL | Import a database from a file to a MySQL database](#56-mysql--import-a-database-from-a-file-to-a-mysql-database)

## 5.Server management

### 5.1. Apache | Create a Virtual Host

To create the folder for the default Virtual Host, replace the ***{LABEL}*** in the below commands as appropriate and then execute it.

    mkdir /srv/www/{VIRTUAL_HOST_FOLDER}
    fixApacheWebRootPermissions.sh

> **Label Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

Copy the file `virtual-host-template.conf` stored at the folder [`/system/apache2/sites-available/`](./system/apache2/sites-available/) of this repository to the server's folder `/etc/apache2/sites-available/` with the following command:

    sudo wget -P /etc/apache2/sites-available/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/apache2/sites-available/virtual-host-template.conf

To rename the file copied with the above command, replace the ***{LABEL}*** in the below command as appropriate and then execute it.

    sudo mv /etc/apache2/sites-available/virtual-host-template.conf /etc/apache2/sites-available/{VIRTUAL_HOST_FOLDER}.conf

> **Label Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

To customize the default Virtual Host configuration file, replace the ***{LABEL}*** in the below command as appropriate and then execute it to open the file with the [*nano text editor*](https://www.nano-editor.org/).

    sudo nano /etc/apache2/sites-available/{VIRTUAL_HOST_FOLDER}.conf

> **Label Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

Within the file, use the command `CTRL + \` to replace the existing labels as explained below.

+ **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
+ **{VIRTUAL_HOST_TLD}** : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host
+ **{SERVER_ADMIN_EMAIL}** : The server's admin e-mail

Check if it's necessary any further modifications, implement it if necessary and when everything is done, save the file with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`. Validate the **Apache Server** configuration with the following command:

    sudo apachectl configtest

To activate the new Virtual Host, replace the ***{LABEL}*** in the below commands as appropriate and then execute it.

    sudo a2ensite {VIRTUAL_HOST_FOLDER}.conf
    sudo systemctl reload apache2

> **Label Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

If the domain of the Virtual Host created with the previous procedure has already its DNS Records pointing to the server's IP address, replace the ***{LABELS}*** in the below URL as appropriate and enter it into a browser’s address bar to test the new local Virtual Host.

      http://VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}

> **Labels Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}** : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

If the domain of the Virtual Host created with the previous procedure doesn't have its DNS Records pointing to the server's IP address it can still [be tested by temporarily modifying the `hosts` file of a local computer](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-20-04#step-6-optional-setting-up-local-hosts-file). This will intercept any requests for the domain that has been configured with previous described procedure and point them to the server, just as the DNS system would do if the domain DNS Records were already pointing to the server's IP address. This will only work from a local computer and is only for testing purposes.

On a LOCAL machine, open the `hosts` file with the *nano text editor* using the following command:

    sudo nano /etc/hosts

Within the file, replace the ***{LABELS}*** in the below snippet as appropriate and then add it to the `hosts` file.

    {SERVER_IP_ADDRESS} {VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}

> **Labels Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}** : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

After making all the necessary changes, save the file with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`. Then, replace the ***{LABELS}*** as appropriate in the below URL and enter it into a browser’s address bar in the local computer where the `hosts` file was edited.

      http://VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}

> **Labels Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}** : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

### 5.2. Apache | Secure Apache with Let's Encrypt

#### 5.2.1. Install Certbot

[The recommended process to install **Certbot**](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal) is with [*snapd*](https://snapcraft.io/docs/installing-snapd). Therefore, execute  the below commands to ensure that the server's version of *snapd* is up to date.

    sudo snap install core
    sudo snap refresh core

Install the [**Certbot**](https://certbot.eff.org/) software on the server with the following command:

    sudo snap install --classic certbot

To ensure that the `certbot` command can be executed, execute the following command:

    sudo ln -s /snap/bin/certbot /usr/bin/certbot

#### 5.2.2. Obtain an SSL Certificate

[Get a SSL certificate](https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-22-04#step-4-obtaining-an-ssl-certificate) and have **Certbot** edit the **Apache Server** configuration automatically to serve it, turning on HTTPS access with the following command:

    sudo certbot --apache

The [SSL certificate](https://www.digicert.com/what-is-an-ssl-certificate) installation script will prompt several questions:

+ The server's admin e-mail;
+ Agreement to the Terms of Service;
+ Request to share the e-mail address with the Electronic Frontier Foundation;
+ List of domains to activate HTTPS for.

After this step, **Certbot**’s configuration is finished and the installation script will present some final remarks about the new certificate and where to locate the generated files.

To test the new SSL certificate, replace the ***{LABELS}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}

> **Labels Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}** : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

If the SSL certificate installation was successful, the site will be redirected to its HTTPS version and the browser’s security indicator will show that the site is properly secured, typically by a lock icon in the address bar.

[SSL Labs Server Test](https://www.ssllabs.com/ssltest/) can be used to verify the certificate’s grade and obtain detailed information about it, from the perspective of an external service.

#### 5.2.3. Verify Certbot Auto-Renewal

[Let’s Encrypt](https://letsencrypt.org/) certificates are only valid for ninety days. Therefore, it is fundamental to automate the certificate renewal process. The **Certbot** package installed takes care of renewals by including a renew script in one of the following locations:

+ `/etc/crontab/`
+ `/etc/cron.*/*`
+ `systemctl list-timers`

This script runs twice a day and will automatically renew any certificate that’s within thirty days of expiration. To check the status of this service and make sure it’s active, [execute the following command](https://community.letsencrypt.org/t/missing-cron-job-or-systemd-timer/153057/2):

    sudo systemctl status snap.certbot.renew.timer

To test the renewal process, execute the following command:

    sudo certbot renew --dry-run

## 5.3. MySQL | Create a MySQL database

To [create a database](https://www.mysqltutorial.org/mysql-create-database/), defining its [Character Set](https://www.mysqltutorial.org/mysql-character-set/) and [Collation](https://www.mysqltutorial.org/mysql-collation/), replace the ***{LABELS}*** in the below command as appropriate and then execute it.

    CREATE DATABASE {DATABASE_NAME} CHARACTER SET {CHARACTER_SET_NAME} COLLATE {COLLATION_NAME};

> **Labels Definition**
>
> + **{DATABASE_NAME}** : The name chosen for the new database;
> + **{CHARACTER_SET_NAME}** : The character set of the new database;
> + **{COLLATION_NAME}** : The collation of the new database.

## 5.4. MySQL | Create a MySQL user

To [create a new user in the MySQL Server](https://www.mysqltutorial.org/mysql-create-user.aspx), replace the ***{LABELS}*** in the below command as appropriate and then execute it.

    CREATE USER '{USERNAME}'@'{HOST}' IDENTIFIED WITH {AUTHENTICATION_PLUGIN} BY '{PASSWORD}';

> **Labels Definition**
>
> + **{USERNAME}** : The new account name in the MySQL Server;
> + **{HOST}** : The name of the host from which the user connects to the MySQL Server;
> + **{AUTHENTICATION_PLUGIN}** : The [Authentication Plugin](https://dev.mysql.com/doc/refman/8.0/en/authentication-plugins.html) to be used to authenticate the new account in the MySQL Server;
> + **{PASSWORD}** : The password of the new account in the MySQL Server.

The [MySQL documentation recommends](https://dev.mysql.com/doc/refman/8.0/en/upgrading-from-previous-series.html#upgrade-caching-sha2-password) the `caching_sha2_password` authentication plugin but there is a known issue with some versions of PHP that causes problems with this plugin and therefore, on databases to be accessed by PHP applications it's better to use the `mysql_native_password` authentication plugin.

## 5.5. MySQL | Grant privileges to a MySQL user

To [grant privileges to a user in the MySQL Server](https://www.mysqltutorial.org/mysql-grant.aspx), replace the ***{LABELS}*** in the below command as appropriate and then execute it.

    GRANT {PRIVILEGE} ON {PRIVILEGE_LEVEL} TO '{USERNAME}'@'{HOST}';

> **Labels Definition**
>
> + **{PRIVILEGE}** : The privilege (or list a privileges separated by coma) to be granted to the MySQL user;
> + **{PRIVILEGE_LEVEL}** : The privilege level to be granted to the MySQL user;
> + **{USERNAME}** : The account name in the MySQL Server to whom the privileges will be assigned.
> + **{HOST}** : The name of the host from which the user connects to the MySQL Server.

To assign all privileges, the **{PRIVILEGE}** label must be replaced with `ALL PRIVILEGES`.

The most common assigned privilege levels are the **Database Privileges** which are assigned in the following syntax:

    {DATABASE_NAME}.{DATABASE_TABLE}

> **Labels Definition**
>
> + **{DATABASE_NAME}** : The database where the MySQL user will be granted privileges;
> + **{TABLE_NAME}** : The table where the MySQL user will be granted privileges.

The assignment of privileges on all tables of a database is done with the following syntax:

    {DATABASE_NAME}.*

## 5.6. MySQL | Import a database from a file to a MySQL database

If the file that is going to be imported to the MySQL database is not already stored on the server, replace the ***{LABELS}*** in the below command as appropriate and execute it **ON A CLIENT MACHINE** to [copy the file using SCP](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) to the server.

    scp -r {PATH_ON_THE_ORIGIN} {HOST_NAME}:{PATH_ON_THE_SERVER}

> **Labels Definition**
>
> + **{PATH_ON_THE_ORIGIN}** : Path of the file on its origin
> + **{HOST_NAME}** : Name given to the server on the SSH Config File
> + **{PATH_ON_THE_SERVER}** : Destiny path of the file on the server

[Import a database](https://www.mysqltutorial.org/mysql-copy-database/) from a file with the below command (replacing the ***{LABELS}*** as explained after the command).

    mysql -u {USERNAME} -p {DATABASE_NAME} < {PATH_TO_THE_FILE}

> **Labels Definition**
>
> + **{USERNAME}** : The user with enough privileges on the MySQL Server to import the database (normally the `root`user);
> + **{DATABASE_NAME}** : The name of the database on the MySQL Server to where the data will be imported;
> + **{PATH_TO_THE_FILE}** : Path to the file which will be imported to the MySQL Server.
