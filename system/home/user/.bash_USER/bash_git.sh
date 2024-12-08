#!/usr/bin/env bash
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains git related custom bash aliases and functions. Source it from the bash_"${USER}".sh file on the
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
# + Enable git tab completion for branch names
# + Change command prompt in repositories
# + Shows '*' in prompt of repositoires with uncommited changes
# + Git related command aliases
# + Git related custom bash functions
#   + set-author()
#   + set-date()
#	  + changed-files()
#   + todos()
#
# ----------------------------------------------------------------------------------------------------------------------

# Enable git tab completion for branch names
#
# The following command is commented because it seems that the current git versions
# are already including this feature and running the command seems to disable it.
# If the feature isn't working, uncomment the below to try to enable it

# source ~/.git_prompt/.git-completion.bash
 
# Change command prompt in repositories
#
# The following command is commented because it seems that the current git versions
# are already including this feature and running the command seems to disable it.
# If the feature isn't working, uncomment the below to try to enable it
#
# source ~/.git_prompt/.git-prompt.sh

# Shows '*' in prompt of repositoires with uncommited changes
# -----------------------------------------------------------
#
export GIT_PS1_SHOWDIRTYSTATE=1

# Git related command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias cgl='clear && git log --oneline -15'
alias gl='git log --oneline -15'
alias cgs='clear && git status'
alias gs='git status'
alias cgls='clear && git log --oneline -15 && git status'
alias gls='git log --oneline -15 && git status'
alias cgd='clear && git diff'
alias gd='git diff'
alias gpr='git pull --rebase'

# Git related custom bash commands
# ----------------------------------------------------------------------------------------------------------------------

# Set the author for the repository
#
# Made with the help of the following resource:
# + https://smarterco.de/set-the-username-and-email-in-git-globally-and-per-project/#set-the-usernameemail-for-a-specific-repository
#
set-author()
{
	echo "This will set the author's name and e-mail for this repository"
	echo "--------------------------------------------------------------"
	echo
	IFS= read -r -p "Type the name of the repository's author: " USERNAME

	if [ ! -z "${USERNAME}" ]
		then
			read -p "Type the e-mail of the repository's author: " EMAIL
	fi

	if [ ! -z "${USERNAME}" ] && [ ! -z "${EMAIL}" ]
		then
			git config user.name "${USERNAME}"
			git config user.email "${EMAIL}"
	fi

	echo
	echo "This repository author is set with the following name and e-mail:"
	echo "-----------------------------------------------------------------"
	git config --get user.name
	git config --get user.email
	echo
}

# Set the date of a commit
#
# Made with the help of the following resource:
#	+ https://smarterco.de/set-the-username-and-email-in-git-globally-and-per-project/#set-the-usernameemail-for-a-specific-repository
#	+ https://www.cyberciti.biz/faq/bash-remove-whitespace-from-string/
#
set-date()
{
	echo "This will set a new date for the last commit"
	echo "--------------------------------------------"
	echo
	echo "The last commit has the following $(git log -1 | grep Date)"
	echo
	IFS= read -r -p "Type, NOT PASTE, the new commit's date using the format displayed above: " NEW_DATE

	if [ ! -z "${NEW_DATE}" ]
		then

			# Remove leading, trailing and multiple white spaces from the string
			NEW_DATE=$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'<<<"${NEW_DATE}")
			NEW_DATE=$(echo "${NEW_DATE}" | xargs)

			echo
			GIT_COMMITTER_DATE=\""${NEW_DATE}"\" git commit --amend --no-edit --date \""${NEW_DATE}"\"

			echo
			echo "The last commit is now set with the following $(git log -1 | grep Date)"
			echo
		else

			echo
			echo "The date of the last commit wasn't changed"
			echo
	fi
}

# List all files changed with a specific commit
 #
 # Made with the help of the following resource:
 #	+ https://stackoverflow.com/a/424142
 #
 changed-files()
 {
    if [ "$#" -eq 0 ]
        then
            echo "Please add a parameter with the hash of the commit to be checked:"
        else
            git diff-tree --no-commit-id --name-only -r "$1"
    fi
 }

# List the lines with TODO in the output of the command
# git diff from the first commit authored by the repos current user
#
# Made with the help of the following resources:
#	+ https://www.tecmint.com/assign-linux-command-output-to-variable/
#	+ https://stackoverflow.com/a/4262780
#	+ https://stackoverflow.com/a/31448684
#	+ https://stackoverflow.com/a/10067297
#	+ https://stackoverflow.com/a/2798833
#	+ https://stackoverflow.com/a/6482403
#
todos()
{
    USERNAME=$(git config user.name)
    FIRST_COMMIT=$(git log --oneline --author="${USERNAME}" --reverse --pretty=format:"%h" | grep -m1 "")

    if [ "$#" -eq 0 ]
        then
            git diff "${FIRST_COMMIT}" | grep TODO: | grep +
        else
            git diff "$1" | grep TODO: | grep +
    fi
}
