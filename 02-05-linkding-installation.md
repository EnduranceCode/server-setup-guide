# Server setup guide

## Introduction

This file contains the [**linkding**](https://linkding.link/) section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

2. Software Installation

    5. [linkding installation](./02-05-linkding-installation.md)
        1. [Install linkding](#251-install-linkding)
        2. [Reverse Proxy Setup](#252-reverse-proxy-setup)
        3. [Create and set an SSL Certificate](#253-create-and-set-an-ssl-certificate)
        4. [www to non-www redirection](#254-www-to-non-www-redirection)

## 2.5. linkding installation

### 2.5.1. Install linkding

[**linkding**](https://linkding.link/) will be [installed](https://linkding.link/installation/) using [Docker](https://www.docker.com/). To prepare the folders necessary for the [**linkding**](https://linkding.link/) installation, execute the following commands:

    sudo mkdir /opt/linkding
    sudo mkdir /opt/linkding/data
    sudo mkdir /opt/linkding/docker-files

The folder `/opt/linkding/docker-files`will contain the files necessary to deploy [**linkding**](https://linkding.link/) with [Docker](https://www.docker.com/). To set better permissions for this folder, replace the ***{LABEL}*** in the below command as appropriate and execute it.

      sudo chown -R {USERNAME}:{USERNAME} /opt/linkding/docker-files/

> **Label Definition**
>
> + **{USERNAME}** : The user that will deploy linkding

We will create a user to manage the [**linkding**](https://linkding.link/) app deployed with [Docker](https://www.docker.com/) and set it as the owner of the folder `/opt/linkding/data/`. To create this user and set it as the owner of the folder `/opt/linkding/data/`, execute the following commands:

    sudo useradd -r -s /usr/sbin/nologin linkding
    sudo chown -R linkding:linkding /opt/linkding/data/

To download the customized [`docker-compose.yml`](./system/opt/linkding/docker-files/docker-compose.yml) and [`.env`](./system/opt/linkding/docker-files/.env) files from this repository to the server, execute the following commands:

    cd /opt/linkding/docker-files/
    wget https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/refs/heads/master/system/opt/linkding/docker-files/docker-compose.yml
    wget https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/refs/heads/master/system/opt/linkding/docker-files/.env

To confirm that the files were downloaded, check the output of the following command:

    ls -lag

Open the files `docker-compose.yml` and `.env` with the [*nano text editor*](https://www.nano-editor.org/) and check if there are any changes needed. If you've made any modification, save it with the command `CTRL + O` and then close the editor with the command `CTRL + X`.

To complete the deployment of [**linkding**](https://linkding.link/), execute the following command:

    docker compose -p linkding up -d

The output of the above command should show that [**linkding**](https://linkding.link/) was deployed with success. For a second confirmation, check the output of the following command:

    docker ps

The above command should show that the [**linkding**](https://linkding.link/) container is being executed.

The [**linkding**](https://linkding.link/) [Docker](https://www.docker.com/) image does not provide an initial user, so you have to create one after setting up the installation. To do so, replace the ***{LABEL}*** in the below command as appropriate and execute it.

      docker exec -it linkding python manage.py createsuperuser --username={USERNAME} --email={EMAIL}

> **Label Definition**
>
> + **{USERNAME}** : The linkding administrator's username
> + **{EMAIL}**    : The linkding administrator's e-mail

To check if [**linkding**](https://linkding.link/) is running correctly, replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}:{LD_HOST_PORT}/

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : The IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`
> + **{LD_HOST_PORT}**      : The port on the host system that the application was published on

### 2.5.2. Reverse Proxy Setup

To ensure that the necessary [*Apache Server*](https://httpd.apache.org/) modules for reverse proxying are enabled, execute the following commands:

    sudo a2enmod proxy
    sudo a2enmod proxy_http
    sudo a2enmod headers
    sudo systemctl reload apache2

Since [**linkding**](https://linkding.link/) version 1.15, the application includes a CSRF check that verifies that the `Origin` request header matches the `Host header`. If the `Host` header is modified by the reverse proxy then this check fails with `403 CSRF verfication failed` error. To fix this, you need to configure the `LD_CSRF_TRUSTED_ORIGINS` option to the URL from which you are accessing your [**linkding**](https://linkding.link/) instance.

Open the`.env` file with the [*nano text editor*](https://www.nano-editor.org/), replace the ***{LABEL}*** in the below snippet as appropriate, and set it as the value of the `LD_CSRF_TRUSTED_ORIGINS` variable.

      http://{REQUEST_DOMAIN}.{REQUEST_TLD},https://{REQUEST_DOMAIN}.{REQUEST_TLD}

> **Label Definition**
>
> + **{REQUEST_DOMAIN}** : The domain (and subdomain if applicable) of the request origin
> + **{REQUEST_TLD}**    : The TLD of the request origin

After making all the necessary changes, save the file with the command `CTRL + O` and then close the editor with the command `CTRL + X`.

To load the new configuration, restart the [**linkding**](https://linkding.link/) executing the following commands:

    cd /opt/linkding/docker-files
    docker compose restart

The output of the above command should show that [**linkding**](https://linkding.link/) was restarted with success. For a second confirmation, check the output of the following command:

    docker ps

The above command should show that the [**linkding**](https://linkding.link/) container is being executed.

To check if [**linkding**](https://linkding.link/) is running correctly, replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}:{LD_HOST_PORT}/

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : The IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`
> + **{LD_HOST_PORT}**      : The port on the host system that the application was published on

To have a domain (or a subdomain) pointing to your [**linkding**](https://linkding.link/) instance, you need to start by [creating the DNS records](https://docs.digitalocean.com/products/networking/dns/how-to/manage-records/) of the desired domain (or subdomain) redirecting to your server's IP address.

After creating the necessary [DNS Records](https://docs.digitalocean.com/products/networking/dns/), create an Apache Virtual Host for that domain (or a subdomain) following the [instructions available in this repository](./03-01-apache-server-management.md#311-apache--create-a-virtual-host). As you are setting a Reverse Proxy, instead of using the file `virtual-host-template.conf` stored at the folder [`/system/apache2/sites-available/`](./system/apache2/sites-available/), use instead the file [`virtual-host-reverse-proxy-template.conf`](./system/etc/apache2/sites-available/virtual-host-reverse-proxy-template.conf). To download this file, execute the following command:

    sudo wget -P /etc/apache2/sites-available/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/refs/heads/master/system/etc/apache2/sites-available/virtual-host-reverse-proxy-template.conf

When customizing the Virtual Host configuration file downloaded with the previous command, besides replacing the ***{LABELS}*** listed on the [provided instructions](./03-01-apache-server-management.md#211-install-apache), replace also the label ***{HOST_PORT}*** with the value set on the [.env](./system/opt/linkding/docker-files/.env) file for the `HOST_PORT` variable.

Check if it's necessary any further modifications, implement it if necessary and when everything is done, save the file with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`. Then, proceed with the creation of a Virtual Host, following the [instructions available in this repository](./03-01-apache-server-management.md#311-apache--create-a-virtual-host).

### 2.5.3. Create and set an SSL Certificate

If [*Certbot*](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal) isn't yet installed on you server, install it and set the SSL certificate for the [**linkding**](https://linkding.link/) instance domain (or a subdomain) following the [instructions available in this repository](./03-01-apache-server-management.md#312-apache--secure-apache-with-lets-encrypt). If you already have SSL Certifcates installed on your server with [*Certbot*](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal), you can expand it to include the new domain or you can create a separate certificate for the new domain.

To expand an existing certificate, replace the ***{LABELS}*** in the below command as appropriate and execute it.

    sudo certbot --apache --cert-name {EXISTING_DOMAIN} --expand -d {EXISTING_DOMAIN} -d {NEW_DOMAIN}

> **Label Definition**
>
> + **{EXISTING_DOMAIN}** : The existing domain (or subdomain) that already has a SSL certificate
> + **{NEW_DOMAIN}**      : The new domain (or subdomain) to be included in the existing SSL certificate

Otherwise, to create a separate certificate for the new domain (or subdomain), replace the ***{LABEL}*** in the below command as appropriate and execute it.

    sudo certbot --apache -d {DOMAIN}

> **Label Definition**
>
> + **{DOMAIN}** : The domain (or subdomain) of the new SSL certificate

Restart the [*Apache Server*](https://httpd.apache.org/) to apply the updated configuration, executing the following command:

    sudo systemctl restart apache2

[SSL Labs Server Test](https://www.ssllabs.com/ssltest/) can be used to verify the certificate’s grade and obtain detailed information about it, from the perspective of an external service.

To test if the [*Certbot*](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal) renewal script includes the new domain (or subdomain), execute the following command:

    sudo certbot renew --dry-run

### 2.5.4. www to non-www redirection

To implement "www to non-www redirection" it's necessary to edit the Virtual Host configuration files (port `80` and port `443`). Start with port `443` Virtual Host file generated by **Certbot**, replace the ***{LABEL}*** in the below command as appropriate and then execute it to open the file with the [*nano text editor*](https://www.nano-editor.org/).

    sudo nano /etc/apache2/sites-available/{VIRTUAL_HOST_FOLDER}-le-ssl.conf

> **Label Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the Virtual Host file to edit

Within the file, replace the ***{LABELS}*** in the below snippet as appropriate and then insert it before the proxy config inside the `<VirtualHost *:443>` block.

    # Redirect www.{SUBDOMAIN}.{VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD} to {SUBDOMAIN}.{VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}
    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.{SUBDOMAIN}\.{VIRTUAL_HOST_FOLDER}\.{VIRTUAL_HOST_TLD}$ [NC]
    RewriteRule ^ https://{SUBDOMAIN}.{VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}%{REQUEST_URI} [L,R=301]

> **Labels Definition**
>
> + **{SUBDOMAIN}**           : The [*subdomain*](https://en.wikipedia.org/wiki/Subdomain), if applicable, of the new Virtual Host
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}**    : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

After making all the necessary changes, save the file with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`. Validate the **Apache Server** configuration with the following command:

    sudo apachectl configtest

If the configuration is correct, it's then time to edit the port `80` Virtual Host file. Replace the ***{LABEL}*** in the below command as appropriate and then execute it to open the file with the [*nano text editor*](https://www.nano-editor.org/).

    sudo nano /etc/apache2/sites-available/{VIRTUAL_HOST_FOLDER}.conf

> **Label Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the Virtual Host file to edit

Within the file, delete the totality of it's content. Then, replace the ***{LABELS}*** in the below snippet as appropriate and then paste it in the file.

    <VirtualHost *:80>

        ServerName {SUBDOMAIN}.{VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}

        ServerAlias www.{SUBDOMAIN}.{VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}

        ServerAdmin {SERVER_ADMIN_EMAIL}

        RewriteEngine on
        RewriteCond %{HTTP_HOST} ^www\.{SUBDOMAIN}\.{VIRTUAL_HOST_FOLDER}\.{VIRTUAL_HOST_TLD}$ [NC]
        RewriteRule ^ https://{SUBDOMAIN}.{VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}%{REQUEST_URI} [L,R=301]

        RewriteCond %{HTTP_HOST} ^{SUBDOMAIN}\.{VIRTUAL_HOST_FOLDER}\.{VIRTUAL_HOST_TLD}$ [NC]
        RewriteRule ^ https://{SUBDOMAIN}.{VIRTUAL_HOST_FOLDER}.{VIRTUAL_HOST_TLD}%{REQUEST_URI} [L,R=301]
    </VirtualHost>

> **Labels Definition**
>
> + **{SUBDOMAIN}**           : The [*subdomain*](https://en.wikipedia.org/wiki/Subdomain), if applicable, of the new Virtual Host
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}**    : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host
> + **{SERVER_ADMIN_EMAIL}**  : The server's admin e-mail

After making all the necessary changes, save the file with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`. Validate the **Apache Server** configuration with the following command:

    sudo apachectl configtest

To activate the new Virtual Host, replace the ***{LABEL}*** in the below commands as appropriate and then execute it.

    sudo a2ensite {VIRTUAL_HOST_FOLDER}.conf
    sudo systemctl reload apache2

> **Label Definition**
>
> + **{VIRTUAL_HOST_FOLDER}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
