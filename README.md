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
2. [Apache Server installation](./02-apache-server-installation.md)
    1. [Install Apache](./02-apache-server-installation.md#21-install-apache)
    2. [Setup the firewall](./02-apache-server-installation.md#22-setup-the-firewall)
    3. [Check the Apache Server](./02-apache-server-installation.md#23-check-the-apache-server)
    4. [Change the Apache Server web root folder](./02-apache-server-installation.md#24-change-the-apache-server-web-root-folder)
    5. [Setup the default directory to be served by Apache Web Server](./02-apache-server-installation.md#25-setup-the-default-directory-to-be-served-by-apache-web-server)
    6. [2.6. Set permissions for the Apache Server root folder](./02-apache-server-installation.md#26-set-permissions-for-the-apache-server-root-folder)
    7. [Keep the Apache Server root folder access permissions consistent with a cron job](./02-apache-server-installation.md#27-keep-the-apache-server-root-folder-access-permissions-consistent-with-a-cron-job)
3. [MySQL Server installation](./03-mysql-server-installation.md)
    1. [Install MySQL](./03-mysql-server-installation.md#31-install-mysql)
    2. [Configure MySQL](./03-mysql-server-installation.md#32-configure-mysql)
    3. [Move MySQL data folder](./03-mysql-server-installation.md#33-move-mysql-data-folder)
4. [PHP installation](./04-php-installation.md)
    1. [Install PHP](./04-php-installation.md#41-install-php)
    2. [Install PHP extensions](./04-php-installation.md#42-install-php-extensions)
    3. [Install FastCGI Process Manager (FPM)](./04-php-installation.md#43-install-fastcgi-process-manager-fpm)
    4. [PHP configuration improvements](./04-php-installation.md#44-php-configuration-improvements)
5. [Server Management](./05-server-management.md)
    1. [Apache | Create a Virtual Host](./05-server-management.md#51-apache--create-a-virtual-host)
    2. [Apache | Secure Apache with Let's Encrypt](./05-server-management.md#52-apache--secure-apache-with-lets-encrypt)
    3. [MySQL | Create a MySQL database](./05-server-management.md##53-mysql--create-a-mysql-database)
    4. [MySQL | Create a MySQL user](./05-server-management.md##54-mysql--create-a-mysql-user)
    5. [MySQL | Grant privileges to a MySQL user](./05-server-management.md##55-mysql--grant-privileges-to-a-mysql-user)
    6. [MySQL | Import a database from a file to a MySQL database](./05-server-management.md##56-mysql--import-a-database-from-a-file-to-a-mysql-database)
