#!/bin/bash
# Set the right permissions on the /srv/www folder
# Built based in the answer at https://superuser.com/a/19333
#
# Set, recursively, the user and group to www-data on the /srv/www folder
chown -R www-data:www-data /srv/www
#
# Make the folder /srv/www and all folders below it, readable, writable, executable by owner and group.
# Set GID on those folder so that all new files and directories created under /srv/www are owned by the www-data group
find /srv/www -type d -exec chmod -c 2755 {} +
#
# Add read and write permissions to user and group to all files under /srv/www
find /srv/www -type f -exec chmod -c 644 {} +
