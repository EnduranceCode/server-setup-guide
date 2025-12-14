# Server setup guide

## Introduction

This file contains the [**traggo**](https://traggo.net/) section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

2. Software Installation

    6. [traggo installation](./02-06-traggo-installation.md)
        1. [Install trago](#261-install-traggo)
        2. [Reverse Proxy Setup](#262-reverse-proxy-setup)
        3. [Create and set an SSL Certificate](#263-create-and-set-an-ssl-certificate)
        4. [www to non-www redirection](#254-www-to-non-www-redirection)

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

To ensure that the necessary [*Apache Server*](https://httpd.apache.org/) modules for reverse proxying are enabled,
execute the following commands:

    sudo a2enmod proxy
    sudo a2enmod proxy_http
    sudo a2enmod headers
    sudo systemctl reload apache2

To have a domain (or a subdomain) pointing to your [**traggo**](https://traggo.net/) instance,
you need to start by 
[creating the DNS records](https://docs.digitalocean.com/products/networking/dns/how-to/manage-records/)
of the desired domain (or subdomain) redirecting to your server's IP address.

After creating the necessary [DNS Records](https://docs.digitalocean.com/products/networking/dns/),
create an Apache Virtual Host for that domain (or a subdomain) following the
[instructions available in this repository](./03-01-apache-server-management.md#311-apache--create-a-virtual-host).
To download the template for the Virtual Host configuration file, execute the following command:

```shell
sudo wget -P /etc/apache2/sites-available/ https://raw.githubusercontent.com/EnduranceCode/system-configuration-files/refs/heads/master/root/etc/apache2/sites-available/virtual-host-template.conf
``` 

When customizing the Virtual Host configuration file downloaded with the previous command, besides
replacing the ***{LABELS}*** listed on the
[provided instructions](./03-01-apache-server-management.md#311-apache--create-a-virtual-host),
execute also the following changes:

+ Replace also the label ***{APP_PORT}*** with the value set on the
  [.env](./system/opt/traggo/docker-files/.env) file for the `HOST_PORT` variable;
+ Change the template's directive `Timeout 300` to `Timeout 10`;
+ Add the options `retry=0 timeout=5` on the directive `ProxyPass`.

[**traggo**](https://traggo.net/) uses [GraphQL](https://graphql.org/) endpoints that can be blocked
by some [ModSecurity](https://modsecurity.org/) rules. To avoid issues with these endpoints, it
can be necessary to add [ModSecurity](https://modsecurity.org/) exclusions to the Virtual Host
configuration file created for the [**traggo**](https://traggo.net/) instance. To do so, add the
just before the closing `</VirtualHost>` tag.


```text
# Fix ModSecurity issues with GraphQL endpoints
<LocationMatch "/graphql">

    # Policy Violation - Disable "Argument value too long" (Rule 920370)
    SecRuleRemoveById 920370

    # Disable ALL RCE rules (932000 to 932999)
    SecRuleRemoveById 932000-932999
        
    # Disable rule 942190 - SQL Injection Attack Detected via libinjection
    SecRuleRemoveById 942190
</LocationMatch>
```

Check if it's necessary any further modifications, implement it if necessary and when everything
is done, save the file with the command `CTRL + O` and then exit the text editor with
the command `CTRL + X`. Then, proceed with the creation of a Virtual Host, following
the [instructions available in this repository](./03-01-apache-server-management.md#311-apache--create-a-virtual-host).

### 2.6.3. Create and set an SSL Certificate

If [*Certbot*](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal) isn't yet installed on you server, install it and set the SSL certificate for the [**traggo**](https://traggo.net/) instance domain (or a subdomain) following the [instructions available in this repository](./03-01-apache-server-management.md#312-apache--secure-apache-with-lets-encrypt). If you already have SSL Certifcates installed on your server with [*Certbot*](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal), you can expand it to include the new domain or you can create a separate certificate for the new domain.

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
