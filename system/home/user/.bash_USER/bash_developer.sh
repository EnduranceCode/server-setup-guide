#!/usr/bin/env bash
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains git related custom bash aliases and fucntions. Source it from the bash_"${USER}".sh file on the
# ~/.bash_"${USER}" folder, adding the below snippet on the referred bash_"${USER}".sh file.
#
#   if [ -f ~/.bash_"${USER}"/bash_git.sh ]; then
#       source ~/.bash_"${USER}"/bash_git.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Global development command aliases
# + Project specific development command aliases
# + Global development custom bash functions
#   + set-eslint()
# + Project specific development custom bash functions
#
# ----------------------------------------------------------------------------------------------------------------------

# Global development command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias code-dev='clear && echo "[code]" && echo "------" && cd ~/code && ls --group-directories-first -la'

alias npm-global='npm list -g --depth 0'

# Project specific development command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias code-endurancetrio='clear && echo "[code/endurancetrio-community]" && echo "------------------------------" && cd ~/code/endurancetrio-community'

# Global development related bash functions
# ----------------------------------------------------------------------------------------------------------------------

# Install and config ESLint in a project's root folder to use with VS Code
#
set-eslint()
{
    npm install --save-dev eslint
    npm install --save-dev eslint-config-prettier
    npm install --save-dev prettier
    npm install --save-dev eslint-plugin-prettier

    echo .
    echo "You now must copy the file .eslintrc.json to the root folder of the project"
}

# Project specific development custom bash functions
# ----------------------------------------------------------------------------------------------------------------------
