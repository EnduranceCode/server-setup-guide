# Server setup guide

## Introduction

This file contains the **[MySQL Server installation](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-22-04)** section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

## Table of Contents

3. [MySQL Server installation](./03-mysql-server-installation.md)
    1. [Install MySQL](#31-install-mysql)
    2. [Configure MySQL](#32-configure-mysql)
    3. [Move MySQL data folder](#33-move-mysql-data-folder)

## 3. MySQL Server installation

### 3.1. Install MySQL

[Install](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-22-04#step-1-installing-mysql) the [*MySQL*](https://www.mysql.com/) with the following commands:

    sudo apt update
    sudo apt install mysql-server

To see the names of the installed packages, use the following command:

    dpkg -l | grep mysql | grep ii

To confirm that the installation was successful and to get the installed **MySQL** version, run the following command:

    mysql --version

The confirm that *MySQL* service is running, run the following command:

    sudo service mysql status

And to check the network status of *MySQL*, run the following command:

    sudo ss -tap | grep mysql

### 3.2. Configure MySQL

As of July 2022, an error will occur while [executing the `mysql_secure_installation`](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-22-04#step-2-configuring-mysql) script without changing the `root` user authentication method.

To change the `root` user authentication method, execute the following commands:

    sudo mysql
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
    exit

Now, after changing the `root` user authentication method, run the `mysql_secure_installation` with the following command:

    sudo mysql_secure_installation

The `mysql_secure_installation` script will prompt several questions:

+ Setup VALIDATE PASSWORD component -> The recommended answer is **Yes**;
+ Level of *password validation policy* -> The recommended answer is **STRONG**;
+ Change the password for `root`-> The answer can be **No**;
+ Remove anonymous user -> The recommended answer is **Yes**;
+ Disallow root login remotely -> The recommended answer is **Yes**;
+ Remove test database and access to it -> The recommended answer is **Yes**;
+ Reload privilege tables -> The recommended answer is **Yes**.

After the execution of the `mysql_secure_installation` script, reset the `root` user authentication method, execute the following commands:

    mysql -u root -p
    ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;

Check which authentication method each of the **MySQL** user accounts use with the following command:

    SELECT user, plugin, host FROM mysql.user;

Exit the **MySQL** *cli* interface with the following command:

    exit

To test the authentication method, run the following command:

    sudo mysql

Exit the **MySQL** prompt with the following command:

    exit

### 3.3. Move MySQL data folder

The instructions given here to move *MySQL* data folder were written taken in consideration the instruction on the tutorial [How To Move a MySQL Data Directory to a New Location on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-move-a-mysql-data-directory-to-a-new-location-on-ubuntu-18-04) and [thins answer](https://dba.stackexchange.com/a/162274/138523) on [StacKExchange Database Administrators](https://dba.stackexchange.com/) which has a very small contribution of mine. ;-)

Start creating the folder to store the *MySQL* data folder with the following command:

    sudo mkdir /srv/db

Check the output of the below command to confirm that the folder was properly created.

    ls --group-directories-first -la /srv/

Open the **MySQL** prompt with the following command:

    sudo mysql

Then, check the output of the below command to get the current **MySQL** data folder.

    SELECT @@datadir;

Take note of the current **MySQL** data folder which by default is probably `/var/lib/mysql/`. In the following instructions it's assumed that this is indeed the case. If it isn't so, make the necessary changes in the commands shown here.

Exit the **MySQL** prompt with the following command:

    exit

To ensure the integrity of the data, shut down MySQL with the following command:

    sudo systemctl stop mysql

To confirm that **MySQL** was properly stopped, check the output of the following command:

    sudo systemctl status mysql

Copy the existing data folder to the new location with the following command:

    sudo rsync -av /var/lib/mysql /srv/db

Compare the output of the below commands to check if everything was properly replicated.

    sudo ls --group-directories-first -la /var/lib/mysql/
    sudo ls --group-directories-first -la /srv/db/mysql/

Rename the current **MySQL** folder, to use it as a backup, with the following command:

    sudo mv /var/lib/mysql /var/lib/mysql.bak

Check the output of the below command to confirm that the folder was properly backed up.

    ls --group-directories-first -la /var/lib/

Edit the file `/etc/mysql/mysql.conf/mysqdld.cnf` to set the new value for the key `datadir`. Open the **MySQL** configuration file (`mysqdld.cnf`) with the [**Nano text editor**](https://www.nano-editor.org/) using the following command:

    sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

Within the file, use the command `CTRL + W` to search for the key `datadir` and replace its line with the following code snippet:

    datadir = /srv/db/mysql

Save the modifications with the command `CTRL + O` and then exit the [Nano text editor](https://www.nano-editor.org/) with the command `CTRL + X`.

[*AppArmor*](https://wiki.ubuntu.com/AppArmor) needs to be configured to let **MySQL** write to the new directory. That is done creating an alias between the default directory and the new location. Open the file `alias` with the [**Nano text editor**](https://www.nano-editor.org/) using the following command:

    sudo nano /etc/apparmor.d/tunables/alias

Within the file, add at the bottom, the following code snippet:

    # The databases are stored in /srv/db:
    alias /var/lib/mysql/ -> /srv/db/mysql/,

The final comma at the end of the above snippet must be included.

Save the modifications with the command `CTRL + O` and then exit the [Nano text editor](https://www.nano-editor.org/) with the command `CTRL + X`.

To make the modifications effective, restart AppArmor with the following command:

    sudo systemctl restart apparmor

The script `mysql -systemd-start` checks for the existence of two default paths (`/var/lib/mysql` and `/var/lib/mysql/mysql`) and **MySQL** won't start if none of those are found. Create a minimal folder structure to pass the script’s environment check with the following command:

    sudo mkdir -p /var/lib/mysql/mysql

Start **MySQL** with the following command:

    sudo systemctl start mysql

To confirm that **MySQL** service is running, check the output of the following command:

    sudo service mysql status

To confirm that the new **MySQL** data folder is properly set, open *My*SQL* cli with the following command:

    sudo mysql

Then, check the output of the below command to get the current **MySQL** data folder.

    SELECT @@datadir;

If everything is properly set, exit the **MySQL** prompt with the following command:

    exit

Then delete the backup of the **MySQL** data folder with the following command:

    sudo rm -Rf /var/lib/mysql.bak

For one final confirmation that **MySQL** is running as it should, restart it with the following command:

    sudo systemctl start mysql

And then, to confirm that it is running, check the output of the following command:

    sudo service mysql status
