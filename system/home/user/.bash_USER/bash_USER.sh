#!/usr/bin/env bash
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains all the necessary bash shell configurations. To be able to use this file, it must be stored
# in the following folder:
#
#   ~/.bash_"${USER}"
#
# Be aware that ${USER} holds the system-defined variable USER value (the current user's name). If the folder mentioned
# above doesn't exist, create it and set the right folder permissions with the following commands:
#
#   mkdir ~/.bash_"${USER}"
#   chmod 700 ~/.bash_"${USER}"
#
# Source it from the ~/.bashrc file on the home folder, adding the below snippet
# to the end of the referred ~/.bashrc file.
#
#   if [ -f ~/.bash_"${USER}/bash_"${USER}.sh ]; then
#       . ~/.bash_"${USER}/bash_"${USER}.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Command prompt customization
# + Generic custom bash aliases and functions
# + Git related custom bash aliases and functions
# + Developer related custom bash aliases and functions
#
# ----------------------------------------------------------------------------------------------------------------------

# Command prompt customization
# ----------------------------------------------------------------------------------------------------------------------

# color codes from https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
# colors!
#
black="\[\033[0;30m\]"
red="\[\033[0;31m\]"
green="\[\033[0;32m\]"
yellow="\[\033[0;33m\]"
blue="\[\033[0;34m\]"
magenta="\[\033[0;35m\]"
cyan="\[\033[0;36m\]"
white="\[\033[0;37m\]"
brightBlack="\[\033[0;90m\]"
brightRed="\[\033[0;91m\]"
brightGreen="\[\033[0;92m\]"
brightYellow="\[\033[0;93m\]"
brightBlue="\[\033[0;94m\]"
brightMagenta="\[\033[0;95m\]"
brightCyan="\[\033[0;96m\]"
brightWhite="\[\033[0;97m\]"
reset="\[\033[0m\]"

# Custom the Bash prompt
#
# '\h'              adds the hostname up to the first '.'
# '\u'              adds the name of the current user to the prompt
# '\W'              adds the name of the current directory
# '\$(__git_ps1)'   adds git-related stuff
#
# Further reading in https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# Newline in Bash Windows solved with "JustoGotcha" comment on Stack Overflow answer https://stackoverflow.com/a/21561763
#
export PS1="$brightMagenta[\h]$reset:$green\u$reset:$red\W$yellow\$(__git_ps1) $reset"$'\n'"$red$ $reset"

# Generic custom bash aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

if [ -f ~/.bash_"${USER}"/bash_generic.sh ]; then
    source ~/.bash_"${USER}"/bash_generic.sh
fi

# Git related custom bash aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

if [ -f ~/.bash_"${USER}"/bash_git.sh ]; then
    source ~/.bash_"${USER}"/bash_git.sh
fi

# Developer related custom bash aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

if [ -f ~/.bash_"${USER}"/bash_developer.sh ]; then
    source ~/.bash_"${USER}"/bash_developer.sh
fi
