#!/usr/bin/env bash
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains generic custom bash aliases and functions. Source it from the bash_"${USER}".sh file on the
# ~/.bash_"${USER}" folder, adding the below snippet on the referred bash_"${USER}".sh file.
#
#   if [ -f ~/.bash_"${USER}"/bash_generic.sh ]; then
#       source ~/.bash_"${USER}"/bash_generic.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Global Command aliases
# + Global Custom bash functions
#   + path()
#
# ----------------------------------------------------------------------------------------------------------------------

# Global command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias ld='ls --group-directories-first -la'

# Global custom bash functions
# ----------------------------------------------------------------------------------------------------------------------

# List PATH variables on a formatted mode as explained on the nixCraft blog
# https://www.cyberciti.biz/faq/howto-print-path-variable/
#
function path()
{
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}
