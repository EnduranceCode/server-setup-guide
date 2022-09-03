#!/bin/bash
# Set the right permissions on the /srv/www folder
# Built based in the answer at https://superuser.com/a/19333
#
# Clear the screen
clear
# List the folders and files on the /srv/www folder
echo
echo "List folders and files on /srv/www folder"
echo
ls --group-directories-first -la /srv/www
# Prints message with script's actions explanation
echo
echo "Set, recursively, the user and group to www-data on the /srv/www folder"
echo "and then give read and write permissions to the same folders and files"
echo
echo -n "Type \"Yes\" to proceed or \"No\" to abort: "
read answer
if [ $answer == "Yes" ]
then
# Set, recursively, the user and group to www-data on the /srv/www folder
sudo chown -R www-data:www-data /srv/www
#
# Make the folder /srv/www and all folders below it, readable, writable, executable by owner and group.
# Set GID on those folder so that all new files and directories created under /srv/www are owned by the www-data group
sudo find /srv/www -type d -exec chmod -c 2770 {} +
#
# Add read and write permissions to user and group to all files under /srv/www
sudo find /srv/www -type f -exec chmod -c 660 {} +
fi
