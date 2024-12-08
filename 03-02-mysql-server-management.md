# Server setup guide

## Introduction

This file contains the **Server management** section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

## Table of Contents

3. Server Management
    2. [MySQL Server management](#32-mysql-server-management)
        1. [MySQL | Create a MySQL database](#321-mysql--create-a-mysql-database)
        2. [MySQL | Create a MySQL user](#322-mysql--create-a-mysql-user)
        3. [MySQL | Grant privileges to a MySQL user](#323-mysql--grant-privileges-to-a-mysql-user)
        4. [MySQL | Import a database from a file to a MySQL database](#324-mysql--import-a-database-from-a-file-to-a-mysql-database)

## 3.2. MySQL Server management

## 3.2.1. MySQL | Create a MySQL database

To [create a database](https://www.mysqltutorial.org/mysql-create-database/), defining its [Character Set](https://www.mysqltutorial.org/mysql-character-set/) and [Collation](https://www.mysqltutorial.org/mysql-collation/), replace the ***{LABELS}*** in the below command as appropriate and then execute it.

    CREATE DATABASE {DATABASE_NAME} CHARACTER SET {CHARACTER_SET_NAME} COLLATE {COLLATION_NAME};

> **Labels Definition**
>
> + **{DATABASE_NAME}** : The name chosen for the new database;
> + **{CHARACTER_SET_NAME}** : The character set of the new database, e.g. `utf8mb4`;
> + **{COLLATION_NAME}** : The collation of the new database, e.g. `utf8mb4_0900_ai_ci`.

## 3.2.2. MySQL | Create a MySQL user

To [create a new user in the MySQL Server](https://www.mysqltutorial.org/mysql-create-user.aspx), replace the ***{LABELS}*** in the below command as appropriate and then execute it.

    CREATE USER '{USERNAME}'@'{HOST}' IDENTIFIED WITH {AUTHENTICATION_PLUGIN} BY '{PASSWORD}';

> **Labels Definition**
>
> + **{USERNAME}** : The new account name in the MySQL Server;
> + **{HOST}** : The name of the host from which the user connects to the MySQL Server;
> + **{AUTHENTICATION_PLUGIN}** : The [Authentication Plugin](https://dev.mysql.com/doc/refman/8.0/en/authentication-plugins.html) to be used to authenticate the new account in the MySQL Server;
> + **{PASSWORD}** : The password of the new account in the MySQL Server.

The [MySQL documentation recommends](https://dev.mysql.com/doc/refman/8.0/en/upgrading-from-previous-series.html#upgrade-caching-sha2-password) the `caching_sha2_password` authentication plugin but there is a known issue with some versions of PHP that causes problems with this plugin and therefore, on databases to be accessed by PHP applications it's better to use the `mysql_native_password` authentication plugin.

## 3.2.3. MySQL | Grant privileges to a MySQL user

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

## 3.2.4. MySQL | Import a database from a file to a MySQL database

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
