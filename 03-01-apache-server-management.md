# Server setup guide

## Introduction

This file contains the **Server management** section of
[my personal guide to set up an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide).
The introduction to this guide as well as its full *Table of Contents* can be found
on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section
is listed below.

## Table of Contents

3. Server Management

    1. [Apache Server management](#31-apache-server-management)
        1. [Apache | Create a Virtual Host](#311-apache--create-a-virtual-host)
        2. [Apache | Secure Apache with Let's Encrypt](#312-apache--secure-apache-with-lets-encrypt)

## 3.1. Apache Server management

### 3.1.1. Apache | Create a Virtual Host

To create the folder for the files served by the default Virtual Host, replace the placeholder
in the below commands as appropriate and then execute it.

```shell
sudo mkdir /srv/www/{SECOND_LEVEL_DOMAIN_SLD}
sudo fixApacheWebRootPermissions.sh
```

> **Placeholder Definition**
>
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

Copy a template for the Virtual Host configuration file, `virtual-host-template.conf`, stored at the
folder `/root/apache2/sites-available/` of the
[system-configuration-files](https://github.com/EnduranceCode/system-configuration-files)
repository to the server's folder `/etc/apache2/sites-available/` with the following command:

```shell
sudo wget -P /etc/apache2/sites-available/ https://raw.githubusercontent.com/EnduranceCode/system-configuration-files/refs/heads/master/root/etc/apache2/sites-available/virtual-host-template.conf
```

To rename the template file copied with the above command, replace the placeholder in the below
command as appropriate and then execute it.

```shell
sudo mv /etc/apache2/sites-available/virtual-host-template.conf /etc/apache2/sites-available/{SECOND_LEVEL_DOMAIN_SLD}.conf
```

> **Placeholder Definition**
>
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

The template provides configuration blocks for the configuration of a main domain and all of its
subdomains. It also includes a 'WWW' to non-WWW redirect. If this is not a desired behavior the
correspondent section must be removed.

If no subdomain exists or is needed, the corresponding section should be removed. If more than one
subdomain is required, simply copy and paste the subdomain section and modify it accordingly.

This template also provides configuration blocks to set up the Apache server as a reverse proxy.
It handles both main domain and subdomain with proper redirects and headers. Remove the
corresponding section(s) if Reverse Proxy functionality is not required.

If the configuration of more than one subdomain is required for the reverse proxy, simply copy and
paste the subdomain section and modify it accordingly.

To customize the Virtual Host configuration file, created from the provided template, open it with
the [*nano text editor*](https://www.nano-editor.org/):

```shell
sudo nano /etc/apache2/sites-available/{SECOND_LEVEL_DOMAIN_SLD}.conf
```

> **Placeholder Definition**
>
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

Within the file, use the command `CTRL + \` to replace the existing placeholders as explained below.

+ **{TOP_LEVEL_DOMAIN_TLD}**    : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host
+ **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
+ **{THIRD_LEVEL_DOMAIN}**      : The [*subdomain*](https://en.wikipedia.org/wiki/Subdomain) of the new Virtual Host
+ **{APP_PORT}**                : The port where the application to be proxied is listening
+ **{SERVER_ADMIN_EMAIL}**      : The server's admin e-mail

Check if it's necessary any further modifications, implement it if required and when everything
is done, save the file with the command `CTRL + O` and then exit the text editor with the command
`CTRL + X`. Validate the **Apache Server** configuration with the following command:

```shell
sudo apachectl configtest
```

To activate the new Virtual Host, replace the placeholder in the below commands as appropriate
and then execute it.

```shell
sudo a2ensite {SECOND_LEVEL_DOMAIN_SLD}.conf
sudo systemctl reload apache2
```

> **Placeholder Definition**
>
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host

If the domain of the Virtual Host created with the previous procedure has already its DNS Records
pointing to the server's IP address, it is easily tested. Replace the placeholder in the below URL
as appropriate and paste it into a browser’s address bar.

```text
http://{SECOND_LEVEL_DOMAIN_SLD}.{TOP_LEVEL_DOMAIN_TLD}
```

> **Placeholder Definition**
>
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{TOP_LEVEL_DOMAIN_TLD}**    : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

If the domain of the Virtual Host created with the previous procedure doesn't have its DNS Records
pointing to the server's IP address it can still be tested. Temporarily
[modify the `hosts` file](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-20-04#step-6-optional-setting-up-local-hosts-file)
of your local computer. This will intercept any requests for the domain that has been configured
with previous described procedure and point them to the server. Just as the DNS system would do
if the domain DNS Records were already pointing to the server's IP address. This will only work
from a local computer and is only for testing purposes.

On a LOCAL machine, open the `hosts` file with the *nano text editor* using the following command:

```shell
sudo nano /etc/hosts
```

Within the file, replace the placeholder in the below snippet as appropriate and then
add it to the `hosts` file.

```text
{SERVER_IP_ADDRESS} {SECOND_LEVEL_DOMAIN_SLD}.{VIRTUAL_HOST_TLD}
```

> **Placeholder Definition**
>
> + **{SERVER_IP_ADDRESS}**       : IP Address of the server that can be obtained with the command `hostname -I` or the command `curl -4 icanhazip.com`
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}**        : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

After making all the necessary changes, save the file with the command `CTRL + O` and then exit
the text editor with the command `CTRL + X`. Replace the placeholder in the below URL as appropriate
and paste it into a browser’s address bar in the local computer where the `hosts` file was edited.

```text
http://{SECOND_LEVEL_DOMAIN_SLD}.{VIRTUAL_HOST_TLD}
```

> **Placeholder Definition**
>
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}**        : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

### 3.1.2. Apache | Secure Apache with Let's Encrypt

#### 3.1.2.1. Install Certbot

[The recommended process to install **Certbot**](https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal)
is with [*snapd*](https://snapcraft.io/docs/installing-snapd). Therefore, execute  the below
commands to ensure that the server's version of *snapd* is up to date.

```shell
sudo snap install core
sudo snap refresh core
```

Install the [**Certbot**](https://certbot.eff.org/) software on the server with the following command:

```shell
sudo snap install --classic certbot
```

To ensure that the `certbot` command can be executed, execute the following command:

```shell
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

#### 3.1.2.2. Obtain an SSL Certificate

[Get an SSL certificate](https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-22-04#step-4-obtaining-an-ssl-certificate)
and have **Certbot** edit the **Apache Server** configuration automatically to serve it,
turning on HTTPS access with the following command:

```shell
sudo certbot --apache
```

The [SSL certificate](https://www.digicert.com/what-is-an-ssl-certificate) installation script
will prompt several questions:

+ The server's admin e-mail;
+ Agreement to the Terms of Service;
+ Request to share the e-mail address with the Electronic Frontier Foundation;
+ List of domains to activate HTTPS for.

After this step, **Certbot**’s configuration is finished, the installation script will present
some final remarks about the new certificate and where to find the generated files.

**Certbot** created a new Virtual Host configuration file for SSL traffic and edited the
`<VirtualHost *:80>` file to redirect the traffic to the SSL connection. However, some adjustments
are still required to the configuration file of the Virtual Host created previously. To do so,
open the `<VirtualHost *:80>` configuration file with the
[*nano text editor*](https://www.nano-editor.org/):

```shell
sudo nano /etc/apache2/sites-available/{SECOND_LEVEL_DOMAIN_SLD}.conf
```

Within the file, and on the static section of the Virtual Host configuration file, delete the
following sections/lines:

```text
    DocumentRoot /srv/www/{SECOND_LEVEL_DOMAIN_SLD}

    # Directory configuration
    <Directory /srv/www/{SECOND_LEVEL_DOMAIN_SLD}>
        Options -Indexes +FollowSymLinks -MultiViews
        # Change to AllowOverride All if runtime configuration via .htaccess is necessary
        AllowOverride None
        Require all granted

        # Security headers
        <IfModule mod_headers.c>
            Header always set X-Content-Type-Options "nosniff"
            Header always set X-Frame-Options "SAMEORIGIN"
        </IfModule>
    </Directory>

    CustomLog ${APACHE_LOG_DIR}/{SECOND_LEVEL_DOMAIN_SLD}_access.log combined
```

Then, to better document the configuration file, add the following comments in place of the removed
sections/lines:

```text
    # DocumentRoot, <Directory> and CustomLog configuration is now defined
    # on the {SECOND_LEVEL_DOMAIN_SLD}-le-ssl.conf configuration file
```

Also, within the same file, and on the Reverse Proxy section of the Virtual Host (if it exists),
delete the following sections/lines:

```text
    ProxyRequests Off

    # Connection Settings
    KeepAlive On
    KeepAliveTimeout 5
    MaxKeepAliveRequests 100
    Timeout 300

    # Forwarding configuration
    ProxyPreserveHost On
    ProxyPass / http://localhost:{APP_PORT}/
    ProxyPassReverse / http://localhost:{APP_PORT}/

    # Headers configuration
    RequestHeader set X-Forwarded-Proto "http"
    RequestHeader set X-Forwarded-Port "80"

    CustomLog ${APACHE_LOG_DIR}/{SECOND_LEVEL_DOMAIN_SLD}_proxy_access.log combined
```

Then, to better document the configuration file, add the following comments in place of the removed
sections/lines:

```text
# ProxyRequests, Connection settings, Forwarding configuration, Headers configuration
# and CustomLog configuration is now defined on the {SECOND_LEVEL_DOMAIN_SLD}-le-ssl.conf
# configuration file
```

Check if it's necessary any further modifications, implement it if required and when everything
is done, save the file with the command `CTRL + O` and then exit the text editor with the command
`CTRL + X`. Validate the **Apache Server** configuration with the following command:

```shell
sudo apachectl configtest
```

**Certbot** created a new Virtual Host configuration file for SSL traffic named
`{SECOND_LEVEL_DOMAIN_SLD}-le-ssl.conf`. This file also needs some tweaks and improvements.
Therefore, to finalize the configuration, open it with the
[*nano text editor*](https://www.nano-editor.org/):

```shell
sudo nano /etc/apache2/sites-available/{SECOND_LEVEL_DOMAIN_SLD}-le-ssl.conf
```

Within the file, to improve the readability, start by setting a proper indentation on the lines
added by **Certbot**. Then, on the Reverse Proxy section of the Virtual Host configuration file
(if it exists), edit the headers section to make it exactly like the following snippet:

```text
# Headers configuration
RequestHeader set X-Forwarded-Proto "https"
RequestHeader set X-Forwarded-Port "443"
```

Check if it's necessary any further modifications, implement it if required and when everything
is done, save the file with the command `CTRL + O`. Then exit the text editor with the command
`CTRL + X`. Validate the **Apache Server** configuration with the following command:

```shell
sudo apachectl configtest
```

Restart the [*Apache Server*](https://httpd.apache.org/) to apply the updated configuration,
executing the following command:

```shell
sudo systemctl restart apache2
```

To test the new SSL certificate, replace the placeholders in the below URL as appropriate
and paste it into a browser’s address bar.

```text
http://{SECOND_LEVEL_DOMAIN_SLD}.{VIRTUAL_HOST_TLD}
```

> **Placeholder Definition**
>
> + **{SECOND_LEVEL_DOMAIN_SLD}** : The [*Second-level domain*](https://en.wikipedia.org/wiki/Second-level_domain) of the new Virtual Host
> + **{VIRTUAL_HOST_TLD}**        : The [TLD](https://en.wikipedia.org/wiki/Top-level_domain) of the new Virtual Host

If the SSL certificate installation was successful, the site will be redirected to its HTTPS
version and the browser’s security indicator will show that the site is properly secured,
typically by a lock icon in the address bar.

[SSL Labs Server Test](https://www.ssllabs.com/ssltest/) can be used to verify the certificate’s
grade and obtain detailed information about it, from the perspective of an external service.


#### 3.1.2.3. Verify Certbot Auto-Renewal

[Let’s Encrypt](https://letsencrypt.org/) certificates are only valid for ninety days. Therefore,
it is fundamental to automate the certificate renewal process. The **Certbot** package installed
takes care of renewals by including a renewal script in one of the following locations:

+ `/etc/crontab/`
+ `/etc/cron.*/*`
+ `systemctl list-timers`

This script runs twice a day and will automatically renew any certificate that’s within thirty days
of expiration. To check the status of this service and make sure it’s active,
[execute the following command](https://community.letsencrypt.org/t/missing-cron-job-or-systemd-timer/153057/2):

```shell
sudo systemctl status snap.certbot.renew.timer
```

To test the renewal process, execute the following command:

```shell
sudo certbot renew --dry-run
```
