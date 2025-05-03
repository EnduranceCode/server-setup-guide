# Server setup guide

## Introduction

This is my personal guide to setup an Ubuntu server. To build this guide I've used the knowledge available on the internet and the sources are, as much as possible, linked on this guide.

I will be updating this guide as my knowledge and experience evolves. I will be glad to take advice, suggestions and/or [pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

## Table of Contents

1. [Initial Setup](./01-initial-server-setup.md)
    1. [Deploy the server](./01-initial-server-setup.md#11-deploy-the-server)
    2. [System update](./01-initial-server-setup.md#12-system-update)
    3. [Create a non root user](./01-initial-server-setup.md#13-create-a-user)
    4. [Setup SSH key-based login](./01-initial-server-setup.md#14-setup-ssh-key-based-login)
    5. [Test the user SSH keys login and secure it](./01-initial-server-setup.md#15-test-the-user-ssh-keys-login-and-secure-it)
    6. [Setup the firewall](./01-initial-server-setup.md#16-setup-the-firewall)
    7. [Git](./01-initial-server-setup.md#17-git)
    8. [Bash prompt customization](./01-initial-server-setup.md#18-bash-prompt-customization)
    9. [Additional folders in the home folder](./01-initial-server-setup.md#19-additional-folders-in-the-home-folder)
2. Software installation
    1. [Apache Server installation](./02-01-apache-server-installation.md)
        1. [Install Apache](./02-01-apache-server-installation.md#211-install-apache)
        2. [Setup the firewall](./02-01-apache-server-installation.md#212-setup-the-firewall)
        3. [Check the Apache Server](./02-01-apache-server-installation.md#213-check-the-apache-server)
        4. [Change the Apache Server web root folder](./02-01-apache-server-installation.md#214-change-the-apache-server-web-root-folder)
        5. [Setup the default directory to be served by Apache Web Server](./02-01-apache-server-installation.md#215-setup-the-default-directory-to-be-served-by-apache-web-server)
        6. [Set permissions for the Apache Server root folder](./02-01-apache-server-installation.md#216-set-permissions-for-the-apache-server-root-folder)
        7. [Keep the Apache Server root folder access permissions consistent with a cron job](./02-01-apache-server-installation.md#217-keep-the-apache-server-root-folder-access-permissions-consistent-with-a-cron-job)
    2. [MySQL Server installation](./02-02-mysql-server-installation.md)
        1. [Install MySQL](./02-02-mysql-server-installation.md#221-install-mysql)
        2. [Configure MySQL](./02-02-mysql-server-installation.md#222-configure-mysql)
        3. [Move MySQL data folder](./02-02-mysql-server-installation.md#223-move-mysql-data-folder)
    3. [PHP installation](./02-03-php-installation.md)
        1. [Install PHP](./02-03-php-installation.md#231-install-php)
        2. [Install PHP extensions](./02-03-php-installation.md#232-install-php-extensions)
        3. [Install FastCGI Process Manager (FPM)](./02-03-php-installation.md#233-install-fastcgi-process-manager-fpm)
        4. [PHP configuration improvements](./02-03-php-installation.md#234-php-configuration-improvements)
    4. [Docker installation](./02-04-docker-installation.md)
        1. [Install Docker](./02-04-docker-installation.md#241-install-docker)
    5. [linkding installation](./02-05-linkding-installation.md)
        1. [Install linkding](./02-05-linkding-installation.md#251-install-linkding)
        2. [Reverse Proxy Setup](./02-05-linkding-installation.md#252-reverse-proxy-setup)
        3. [Create and set an SSL Certificate](./02-05-linkding-installation.md#253-create-and-set-an-ssl-certificate)
        4. [www to non-www redirection](./02-05-linkding-installation.md#254-www-to-non-www-redirection)
    6. [traggo installation](./02-06-traggo-installation.md)
        1. [Install traggo](./02-06-traggo-installation.md#261-install-traggo)
        2. [Reverse Proxy Setup](./02-06-traggo-installation.md#262-reverse-proxy-setup)
        3. [Create and set an SSL Certificate](./02-06-traggo-installation.md#263-create-and-set-an-ssl-certificate)
        4. [www to non-www redirection](./02-06-traggo-installation.md#254-www-to-non-www-redirection)
3. Server Management
    1. [Apache Server Management](./03-01-apache-server-management.md)
        1. [Apache | Create a Virtual Host](./03-01-apache-server-management.md#311-apache--create-a-virtual-host)
        2. [Apache | Secure Apache with Let's Encrypt](./03-01-apache-server-management.md#312-apache--secure-apache-with-lets-encrypt)
        3. [Apache | www to non-www redirection](./03-01-apache-server-management.md#313-apache--www-to-non-www-redirection)
    2. [MySQL Server Management](./03-02-mysql-server-management.md)
        1. [MySQL | Create a MySQL database](./03-02-mysql-server-management.md#321-mysql--create-a-mysql-database)
        2. [MySQL | Create a MySQL user](./03-02-mysql-server-management.md#322-mysql--create-a-mysql-user)
        3. [MySQL | Grant privileges to a MySQL user](./03-02-mysql-server-management.md#323-mysql--grant-privileges-to-a-mysql-user)
        4. [MySQL | Import a database from a file to a MySQL database](./03-02-mysql-server-management.md#324-mysql--import-a-database-from-a-file-to-a-mysql-database)
4. [Linux Upskill Challenge | Resources & Extensions](./04-linux-upskill-challenge.md)
    1. [Day 1 | Get to know your server](./04-linux-upskill-challenge.md#41-day-1--get-to-know-your-server)
