# Server setup guide

## Introduction

This file contains the **[PHP installation](https://www.digitalocean.com/community/tutorials/how-to-install-php-8-1-and-set-up-a-local-development-environment-on-ubuntu-22-04)** section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

2. Software Installation

    3. [PHP installation](./02-03-php-installation.md)
        1. [Install PHP](#231-install-php)
        2. [Install PHP extensions](#232-install-php-extensions)
        3. [Install FastCGI Process Manager (FPM)](#233-install-fastcgi-process-manager-fpm)
        4. [PHP configuration improvements](#234-php-configuration-improvements)

## 2.3. PHP installation

### 2.3.1. Install PHP

#### 2.3.1.1. Install the default PHP version available on Ubuntu's repositories

[Install](https://www.digitalocean.com/community/tutorials/how-to-install-php-8-1-and-set-up-a-local-development-environment-on-ubuntu-22-04) the [**PHP**](https://www.php.net/) server with the following commands:

    sudo apt update
    sudo apt install php libapache2-mod-php

To confirm that the installation was successful and to get the installed **PHP** version, execute the following command:

    php --version

To see the names of the installed packages, execute the following command:

    dpkg -l | grep php | grep ii

To reload the *Apache Server*, execute the following command:

    sudo systemctl reload apache2

To be able to retrieve [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), use the below command to download the file `info.php`, stored in this repository, to the default directory served by Apache Web Server.

    sudo wget -P /srv/www/html/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/srv/www/html/info.php

To display the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

For safety reasons, the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php) shouldn't be publicly available. Therefore, the file `info.php` must be deleted with the following command:

    sudo rm /srv/www/html/info.php

#### 2.3.1.2. Install a specific PHP version

[Install](https://linux.how2shout.com/how-to-install-php-7-4-on-ubuntu-22-04-lts-jammy-linux/) a specific version of the [**PHP**](https://www.php.net/) server, replace the ***{LABEL}*** in the below commands as appropriate and execute it.

    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php -y
    sudo add-apt-repository ppa:ondrej/apache2 -y
    sudo apt update
    sudo apt install php{PHP_VERSION}

> **Label Definition**
>
> + **{PHP_VERSION}** : The desired PHP version tag, e.g. 7.4

To confirm that the installation was successful and to get the installed **PHP** version, execute the following command:

    php --version

To see the names of the installed packages, execute the following command:

    dpkg -l | grep php | grep ii

When using more than one **PHP** version on the same system, set the default one choosing one of the *Selection*”* numbers of the **PHP** versions listed with the following command:

    sudo update-alternatives --config php

To reload the *Apache Server*, execute the following command:

    sudo systemctl reload apache2

To be able to retrieve [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), use the below command to download the file `info.php`, stored in this repository, to the default directory served by Apache Web Server.

    sudo wget -P /srv/www/html/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/srv/www/html/info.php

To display the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

For safety reasons, the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php) shouldn't be publicly available. Therefore, the file `info.php` must be deleted with the following command:

    sudo rm /srv/www/html/info.php

### 2.3.2. Install PHP extensions

#### 2.3.2.1. Install PHP extensions of the default PHP version available on Ubuntu's repositories

**PHP** extensions are compiled libraries that extend the core functionality of this scripting language. Extensions are available as packages and can be easily installed with the `apt` command. Extensions like `libapache2-mod-php` and `php-mysql` are fundamental to run **PHP** in conjunction with the *Apache Server* and *MySQL* but there are a few more that are also quite useful. Based on the research I've made, I choose to install the following set of **PHP** extensions:

+ php-bcmath
+ php-bz2
+ php-cli
+ php-common
+ php-curl
+ php-gd
+ php-imagick
+ php-intl
+ php-json
+ php-mbstring
+ php-mysql
+ php-xml
+ php-zip

Before installing the above listed **PHP** extensions, install [ImageMagick](https://imagemagick.org/) (required for `php-imagick`) with the following command:

    sudo apt install imagemagick

The previously listed **PHP** extensions will be installed with the following command:

    sudo apt update && sudo apt install php-bcmath php-bz2 php-cli php-common php-curl php-gd php-imagick php-json php-mbstring php-mysql php-xml php-zip

To see the names of the installed packages, execute the following command:

    dpkg -l | grep php | grep ii

To activate the new configuration, execute the following command:

    sudo systemctl reload apache2

To be able to retrieve the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), download the file `info.php`, stored in this repository, to the default directory served by Apache Web Server, using the following command:

    sudo wget -P /srv/www/html/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/srv/www/html/info.php

To display [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

For safety reasons, the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php) shouldn't be publicly available. Therefore, the file `info.php` must be deleted with the following command:

    sudo rm /srv/www/html/info.php

#### 2.3.2.2. Install PHP extensions of a specific PHP version

**PHP** extensions are compiled libraries that extend the core functionality of this scripting language. Extensions are available as packages and can be easily installed with the `apt` command. Extensions like `libapache2-mod-php` and `php-mysql` are fundamental to run **PHP** in conjunction with the *Apache Server* and *MySQL* but there are a few more that are also quite useful. Based on the research I've made, I choose to install the following set of **PHP** extensions:

+ php-bcmath
+ php-bz2
+ php-cli
+ php-common
+ php-curl
+ php-gd
+ php-imagick
+ php-intl
+ php-json
+ php-mbstring
+ php-mysql
+ php-xml
+ php-zip

Before installing the above listed **PHP** extensions, install [ImageMagick](https://imagemagick.org/) (required for `php-imagick`) with the following command:

    sudo apt install imagemagick

To install the previously listed **PHP** extensions, replace the ***{LABEL}*** in the below commands as appropriate and execute it.

    sudo apt update && sudo apt install php{PHP_VERSION}-bcmath php{PHP_VERSION}-bz2 php{PHP_VERSION}-cli php{PHP_VERSION}-common php{PHP_VERSION}-curl php{PHP_VERSION}-gd php{PHP_VERSION}-imagick php{PHP_VERSION}-json php{PHP_VERSION}-mbstring php{PHP_VERSION}-mysql php{PHP_VERSION}-xml php{PHP_VERSION}-zip

> **Label Definition**
>
> + **{PHP_VERSION}** : The desired PHP version tag, e.g. 7.4

To see the names of the installed packages, execute the following command:

    dpkg -l | grep php | grep ii

To activate the new configuration, execute the following command:

    sudo systemctl reload apache2

To be able to retrieve the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), download the file `info.php`, stored in this repository, to the default directory served by Apache Web Server, using the following command:

    sudo wget -P /srv/www/html/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/srv/www/html/info.php

To display [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

For safety reasons, the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php) shouldn't be publicly available. Therefore, the file `info.php` must be deleted with the following command:

    sudo rm /srv/www/html/info.php

### 2.3.3. Install FastCGI Process Manager (FPM)

#### 2.3.3.1. Install FastCGI Process Manager (FPM) for the default PHP version available on Ubuntu's repositories

To install [FastCGI Process Manager (FPM)](https://www.php.net/manual/en/install.fpm.php), execute the following command:

    sudo apt install php-fpm

To enable FPM in Apache2 execute the following commands:

    sudo a2enmod proxy_fcgi setenvif
    sudo a2enconf php-fpm

To activate the new configuration, you need to execute the following command:

    sudo systemctl reload apache2

To be able to retrieve [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), use the below command to download the file `info.php`, stored in this repository, to the default directory served by Apache Web Server.

    sudo wget -P /srv/www/html/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/srv/www/html/info.php

To display the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

For safety reasons, the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php) shouldn't be publicly available. Therefore, the file `info.php` must be deleted with the following command:

    sudo rm /srv/www/html/info.php

#### 2.3.3.2. Install FastCGI Process Manager (FPM) for a specific PHP version

To install [FastCGI Process Manager (FPM)](https://www.php.net/manual/en/install.fpm.php), replace the ***{LABEL}*** in the below commands as appropriate and execute it.

    sudo apt install php{PHP_VERSION}-fpm

> **Label Definition**
>
> + **{PHP_VERSION}** : The desired PHP version tag, e.g. 7.4

To enable FPM in Apache2, replace the ***{LABEL}*** in the below commands as appropriate and execute it.

    sudo a2enmod proxy_fcgi setenvif
    sudo a2enconf php{PHP_VERSION}-fpm

> **Label Definition**
>
> + **{PHP_VERSION}** : The desired PHP version tag, e.g. 7.4

To activate the new configuration, you need to execute the following command:

    sudo systemctl reload apache2

To be able to retrieve [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), use the below command to download the file `info.php`, stored in this repository, to the default directory served by Apache Web Server.

    sudo wget -P /srv/www/html/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/srv/www/html/info.php

To display the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

For safety reasons, the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php) shouldn't be publicly available. Therefore, the file `info.php` must be deleted with the following command:

    sudo rm /srv/www/html/info.php

### 2.3.4. PHP configuration improvements

**PHP** has (at least) three configuration files (`php.ini`) that, depending on its purposes, have three different locations. Those [three locations](https://askubuntu.com/a/356990) are the following:

+ `/etc/php/{PHP_VERSION_NUMBER}/apache2/php.ini` -> Affects the **PHP** plugin used by the *Apache Server*
+ `/etc/php/{PHP_VERSION_NUMBER}/cli/php.ini` -> Affects the **PHP** executed in the terminal
+ `/etc/php/{PHP_VERSION_NUMBER}/fpm/php.ini` -> Affects the **PHP** plugin used by the *Apache Server* with [PHP FPM](https://www.php.net/manual/en/install.fpm.php)

> **Label Definition**
>
> + **{PHP_VERSION_NUMBER}** : The **PHP** version number installed on the server

The location of the `php.ini` file in use is mapped by the *"Loaded Configuration file"* key on the [page with information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php). To be able to retrieve the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), use the below command to download the file `info.php`, stored in this repository, to the default directory served by Apache Web Server.

    sudo wget -P /srv/www/html/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/srv/www/html/info.php

To display the [information about the system's current state of PHP](https://www.php.net/manual/en/function.phpinfo.php), replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

Replace the ***{LABEL}*** in the below command as appropriate and execute it to edit the `php.ini` file with the [**nano text editor**](https://www.nano-editor.org/).

    sudo nano {LOADED_CONFIGURATION_FILE_VALUE}

> **Label Definition**
>
> + **{LOADED_CONFIGURATION_FILE_VALUE}** : Value of the key *Loaded Configuration File* on the page with information about the system's current state of PHP

Then, use the command `CTRL + W` to search for the directives shown on the below snippet and replace its values with the ones shown on the mentioned snippet.

+ upload_max_filesize = 64M
+ post_max_size = 72M
+ max_execution_time = 360
+ max_input_time = 120
+ max_input_vars = 1000
+ memory_limit = 512M
+ sendmail_path = /usr/sbin/sendmail -t -i

To confirm that the above specified *sendmail* path is indeed correct, compare it with the output of the below command and if necessary use it on the `php.ini` file.

    which sendmail

To activate the new configuration, execute the following command:

    sudo systemctl reload apache2

To test if **PHP** is running properly, try to display the [information about the current state of PHP](https://www.php.net/manual/en/function.phpinfo.php). Do it replacing the ***{LABEL}*** in the below URL as appropriate and entering it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}/info.php

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`

For safety reasons, the [information about the current state of PHP](https://www.php.net/manual/en/function.phpinfo.php) shouldn't be publicly available. Therefore, the file `info.php` must be deleted with the following command:

    sudo rm /srv/www/html/info.php

To test if the e-mail functionality is properly set on *PHP*, use the script shared on the [Conetix](https://conetix.com.au)'s support article [Simple PHP Mail test](https://conetix.com.au/support/simple-php-mail-test/). First, copy the mentioned script, stored in this repository, to the user's home folder, using the following command:

    wget -P ~/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/master/system/home/user/test-email.php

 The file `test-email.php` must be edited set the correct e-mail addresses. Use the [*nano text editor*](https://www.nano-editor.org/) to edit the mentioned file executing the following command:

    sudo nano ~/test-email.php

Within the file, use the command `CTRL + W` to search for the e-mail address labels and replace it as shown in the below *Label Definition* section.

> **Label Definition**
>
> + **{FROM_EMAIL_ADDRESS}** : Sending e-mail address configured on *sendmail*
> + **{TO_EMAIL_ADDRESS}** : Destination address of the test e-mail

Then, execute the following command:

    php ~/test-email.php

If everything is fine, an e-mail shall be received in the e-mail inbox defined in the file `test-email.php`.
