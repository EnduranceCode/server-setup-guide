# Server setup guide

## Introduction

This file contains the [**traggo**](https://traggo.net/) section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

2. Software Installation

    6. [traggo installation](./02-06-traggo-installation.md)
        1. [Install trago](#261-install-traggo)
        2. [Reverse Proxy Setup](#262-reverse-proxy-setup)
        3. [Create and set an SSL Certificate](#263-create-and-set-an-ssl-certificate)

## 2.6. traggo installation

### 2.6.1. Install traggo

[**traggo**](https://traggo.net/) will be [installed](https://traggo.net/install/) using [Docker](https://www.docker.com/). To prepare the folders necessary for the [**traggo**](https://traggo.net/) installation, execute the following commands:

    sudo mkdir /opt/traggo
    sudo mkdir /opt/traggo/data
    sudo mkdir /opt/traggo/docker-files

The folder `/opt/traggo/docker-files`will contain the files necessary to deploy [**traggo**](https://traggo.net/) with [Docker](https://www.docker.com/). To set better permissions for this folder, replace the ***{LABEL}*** in the below command as appropriate and execute it.

      sudo chown -R {USERNAME}:{USERNAME} /opt/traggo/docker-files/

> **Label Definition**
>
> + **{USERNAME}** : The user that will deploy traggo

We will create a user to manage the [**traggo**](https://traggo.net/) app deployed with [Docker](https://www.docker.com/) and set it as the owner of the folder `/opt/traggo/data/`. To create this user and set it as the owner of the folder `/opt/traggo/data/`, execute the following commands:

    sudo useradd -r -s /usr/sbin/nologin traggo
    sudo chown -R traggo:traggo /opt/traggo/data/

To download the customized [`docker-compose.yml`](./system/opt/traggo/docker-files/docker-compose.yml) and [`.env`](./system/opt/traggo/docker-files/.env) files from this repository to the server, execute the following commands:

    cd /opt/linkding/docker-files/
    wget https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/refs/heads/master/system/opt/traggo/docker-files/docker-compose.yml
    wget https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/refs/heads/master/system/opt/traggo/docker-files/.env

To confirm that the files were downloaded, check the output of the following command:

    ls -lag

Open the file `docker-compose.yml` and replace the values for [TRAGGO_DEFAULT_USER_NAME](https://traggo.net/config/) and [TRAGGO_DEFAULT_USER_PASS](https://traggo.net/config/) with the desired values and then check if any further modification is necessary. After making all the desired modifications, save the file with the command `CTRL + O` and then close the editor with the command `CTRL + X`.

Open the file `.env` with the [*nano text editor*](https://www.nano-editor.org/) and check if there are any changes needed. If you've made any modification, save it with the command `CTRL + O` and then close the editor with the command `CTRL + X`.

To complete the deployment of [**traggo**](https://traggo.net/), execute the following command:

    docker compose -p traggo up -d

The output of the above command should show that [**traggo**](https://traggo.net/) was deployed with success. For a second confirmation, check the output of the following command:

    docker ps

The above command should show that the [**traggo**](https://traggo.net/) container is being executed.

To check if [**traggo**](https://traggo.net/) is running correctly, replace the ***{LABEL}*** in the below URL as appropriate and enter it into a browser’s address bar.

      http://{SERVER_IP_ADDRESS}:{HOST_PORT}/

> **Label Definition**
>
> + **{SERVER_IP_ADDRESS}** : The IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`
> + **{HOST_PORT}**      : The port on the host system that the application was published on

### 2.6.2. Reverse Proxy Setup

To ensure that the necessary [*Apache Server*](https://httpd.apache.org/) modules for reverse proxying are enabled, execute the following commands:

    sudo a2enmod proxy
    sudo a2enmod proxy_http
    sudo a2enmod headers
    sudo systemctl reload apache2

To have a domain (or a subdomain) pointing to your [**traggo**](https://traggo.net/) instance, you need to start by [creating the DNS records](https://docs.digitalocean.com/products/networking/dns/how-to/manage-records/) of the desired domain (or subdomain) redirecting to your server's IP address.

After creating the necessary [DNS Records](https://docs.digitalocean.com/products/networking/dns/), create an Apache Virtual Host for that domain (or a subdomain) following the [instructions available in this repository](./03-01-apache-server-management.md#311-apache--create-a-virtual-host). As you are setting a Reverse Proxy, instead of using the file `virtual-host-template.conf` stored at the folder [`/system/apache2/sites-available/`](./system/apache2/sites-available/), use instead the file [`virtual-host-reverse-proxy-template.conf`](./system/etc/apache2/sites-available/virtual-host-reverse-proxy-template.conf). To download this file, execute the following command:

    sudo wget -P /etc/apache2/sites-available/ https://raw.githubusercontent.com/EnduranceCode/server-setup-guide/refs/heads/master/system/etc/apache2/sites-available/virtual-host-reverse-proxy-template.conf

When customizing the Virtual Host configuration file downloaded with the previous command, besides replacing the ***{LABELS}*** listed on the [provided instructions](./03-01-apache-server-management.md#211-install-apache), execute also the following changes:

+ Replace also the label ***{HOST_PORT}*** with the value set on the [.env](./system/opt/traggo/docker-files/.env) file for the `HOST_PORT` variable;
+ Add the options `retry=0 timeout=5` on the directive `ProxyPass`.

Check if it's necessary any further modifications, implement it if necessary and when everything is done, save the file with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`. Then, proceed with the creation of a Virtual Host, following the [instructions available in this repository](./03-01-apache-server-management.md#311-apache--create-a-virtual-host).

### 2.6.3. Create and set an SSL Certificate

If [*Certbot*](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal) isn't yet installed on you server, install it and set the SSL certificate for the [**traggo**](https://traggo.net/) instance domain (or a subdomain) following the [instructions available in this repository](./03-01-apache-server-management.md#312-apache--secure-apache-with-lets-encrypt). If you already have SSL Certifcates installed on your server with [*Certbot*](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal), you can expand it to include the new domain or you can create a separate certificate for the new domain.

To expand an existing certificate, replace the ***{LABELS}*** in the below command as appropriate and execute it.

    sudo certbot --apache -d {EXISTING_DOMAIN} -d {NEW_DOMAIN}

> **Label Definition**
>
> + **{EXISTING_DOMAIN}** : The existing domain (or subdomain) that already has a SSL certificate
> + **{DOMAIN}**          : The new domain (or subdomain) to be included in the existing SSL certificate

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
