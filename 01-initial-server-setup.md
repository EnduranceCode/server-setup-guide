# Server setup guide

## Introduction

This file contains the **[Initial server setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04)** section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

## Table of Contents

1. [Initial Setup](#1-initial-server-setup)
    1. [Deploy the server](#11-deploy-the-server)
    2. [System update](#12-system-update)
    3. [Create a non root user](#13-create-a-user)
    4. [Setup SSH key-based login](#14-setup-ssh-key-based-login)
    5. [Test the user SSH keys login and secure it](#15-test-the-user-ssh-keys-login-and-secure-it)
    6. [Setup the firewall](#16-setup-the-firewall)
    7. [Setup the firewall](#17-git)
    8. [Bash prompt customization](#18-bash-prompt-customization)
    9. [Additional folders in the home folder](#19-additional-folders-in-the-home-folder)

## 1. Initial server setup

### 1.1. Deploy the server

Choose the cloud provider and deploy the server with the latest [Ubuntu LTS version](https://ubuntu.com/about/release-cycle).

For security reasons, disable password login and set [SSH Keys](https://www.atlassian.com/git/tutorials/git-ssh) as the only login method.

### 1.2. System update

Newly deployed servers only have a `root` account set up, therefore, the first login on the server must be done with this account. To update the server's system software, login with the provided user (normally `root`) and execute the following command:

    apt update
    apt full-upgrade

### 1.3. Create a user

As it is more secure to login with a user other than the `root` user, replace the labels as appropriate in the below command and use it to [create a new user](https://linuxize.com/post/how-to-add-and-delete-users-on-ubuntu-20-04/). When prompted provide the new user's password (providing an answer to the subsequent questions is optional).

    sudo adduser {USERNAME}

> + **{USERNAME}** : Name of the new user account

To enable the newly created user to perform administrative tasks, replace the labels as appropriate in the below command and use it to [add the user to the `sudo` group](https://linuxize.com/post/how-to-add-user-to-group-in-linux/).

    usermod -aG sudo {USERNAME}

> + **{USERNAME}** : Name of the user account to be added to the `sudo` group

Replace the labels as appropriate in the below command and use it to login as the newly created user.

    su - {USERNAME}

> + **{USERNAME}** : Name of the user account

Then check the output of the following command:

    sudo -l

To double check if the user has root privileges, perform a system update with the following commands:

    sudo apt update
    sudo apt full-upgrade

### 1.4. Setup SSH key-based login

As the server was deployed to only accept [SSH key-based login](https://linuxize.com/post/how-to-setup-passwordless-ssh-login/), it is necessary to [enable the SSH key-based login](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-22-04) for the created user.

If not already logged as the new user, replace the labels as appropriate in the below command and execute it to login with the correct user account.

    su - {USERNAME}

> + **{USERNAME}** : Name of the user account on the server

Make sure that the user's `~/.ssh` directory is created with the following command:

    mkdir -p ~/.ssh

Add the client's public SSH Key to the server's `authorized_keys` file (ON THE SERVER user's `~/.ssh` directory), replace the labels as appropriate in the below command and execute it on the server

    echo {SSH_KEY} >> ~/.ssh/authorized_keys

> + **{SSH_KEY}** : The public SSH key of the client machine obtained executing the command `cat ~/.ssh/id_rsa.pub` on the client machine

Set the proper permissions on the created directory and files, replace the labels as appropriate in the below commands and execute it.

    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
    chown -R {USERNAME}:{USERNAME} ~/.ssh

> + **{USERNAME}** : Name of the user account on the server

After setting the SSH for the created user, log back with the root user with the following command:

    exit

To logout from the server, execute the following command:

    exit

### 1.5. Test the user SSH keys login and secure it

To make the login in the server process easier, [set the SSH Config File](https://linuxize.com/post/using-the-ssh-config-file/). ON THE CLIENT machine edit (or create) the SSH Config File with the following command:

    nano ~/.ssh/config

And then, replace the labels as appropriate in the below snippet and paste it on a new line of the opened file.

    host    {HOST_NAME}
            hostname {SERVER_IP_ADDRESS}
            User {USERNAME}

> + **{HOST_NAME}** : Name given to the server
> + **{SERVER_IP_ADDRESS}** : IP Address of the server
> + **{USERNAME}** : Name of the user account on the server

Save the changes with the command `ctrl + o` and the exit the [nano editor](https://www.nano-editor.org/) with the command `ctrl + x`.

Try to login on the server with the following command (replace the label `{HOST_NAME}` with the name given to the server and used on the `~/.ssh/config` file):

    ssh {HOST_NAME}

> + **{HOST_NAME}** : Name given to the server

If the login on the server was successful, it's now possible to confirm that SSH password login is not allowed. To do that, open the SSH configuration file `/etc/ssh/sshd_config` with the following command:

    sudo nano /etc/ssh/sshd_config

Then, search in the file for the directives shown on the below snippet and if necessary modify it accordingly:

    PasswordAuthentication no
    ChallengeResponseAuthentication no
    UsePAM no
    PermitRootLogin no

The directive `PermitRootLogin no` will disable [SSH root login](https://www.tecmint.com/disable-or-enable-ssh-root-login-and-limit-ssh-access-in-linux/) which will enhance security because any hacker can try to brute force the root password and gain access to the system.

Save the changes with the command `ctrl + o` and then exit the [nano editor](https://www.nano-editor.org/) with the command `ctrl + x`.

Make sure that the changes made are effective by restarting the SSH service with the following command:

    sudo systemctl restart ssh

Logout the server with the following command:

    exit

And then, to test that everything is still working perfectly, try to login on the server with the following command (replace the label `{HOST_NAME}` with the name given to the server and used on the `~/.ssh/config` file):

    ssh {HOST_NAME}

> + **{HOST_NAME}** : Name given to the server on the SSH Config File

If the login on the server was successful, everything is correctly configured

### 1.6. Setup the firewall

[**UFW**](https://launchpad.net/ufw) is installed by default on Ubuntu. Check if it is installed with the following command:

    which ufw

If **UFW** isn't installed, solve the problem with the following commands:

    sudo apt update
    sudo apt install ufw

Check the status of the **UFW** service with the following command:

    sudo ufw status verbose

#### 1.6.1. Enable IPV6

Start to [setup **UFW**](https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-ubuntu-20-04/), by making sure that [IPV6 is enable](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-1-using-ipv6-with-ufw-optional). Do it by running the following command:

    cat /etc/default/ufw | grep IPV6

If the output of the above command shows the below snippet, IPV6 is already enabled.

    IPV6=yes

If IPV6 is not yet enable, edit the file `/etc/default/ufw` accordingly with the [nano editor](https://www.nano-editor.org/) with the following command:

    sudo nano /etc/default/ufw

Make the necessary changes and then save it with the command `ctrl + o` and the exit the [nano editor](https://www.nano-editor.org/) with the command `ctrl + x`.

#### 1.6.2. Setup the default policies

Setup **UFW**'s [default policies](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-2-setting-up-default-policies) with the following commands:

    sudo ufw default deny incoming
    sudo ufw default allow outgoing

#### 1.6.3. Allow SSH Connections

[Allow SSH Connections](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-3-allowing-ssh-connections) with the following command:

    sudo ufw allow ssh

#### 1.6.4. Enable

[Enable **UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-4-enabling-ufw) with the following command:

    sudo ufw enable

There will be a warning that says the command may disrupt existing SSH connections but as the command that allows SSH connections has already been executed, it should be fine to continue. Therefore, it's save to respond to the prompt with `y` and enable **UFW**.

### 1.7. Git

To check if [**Git**](https://git-scm.com) is already installed on the system, run the following command:

    which git && git --version

If necessary, [install **Git**](https://help.ubuntu.com/lts/serverguide/git.html), with the following command:

    sudo apt update && sudo apt install git

Replace the labels as appropriate in the below command and use it to set [**Git**'s global configuration](https://www.learnenough.com/git-tutorial#sec-installation_and_setup). Instructions for a more detailed **Git** global configuration can be found in [Git's Official Documentation](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).

    git config --global user.name "{USER}"
    git config --global user.email {EMAIL}
    git config --global core.editor nano
    git config --list

> + **{USER}** : Name of the **Git** user
> + **{EMAIL}** : Public e-mail of the **Git** user

### 1.8. Bash prompt customization

The file [.bash_endurancecode](system/home/user/.bash_endurancecode) that's going to be used to customize the bash environment is stored at the folder `system/home/user/` of this repository. The auxiliary files that will eventually be needed are stored at the folder `system/home/user/.git_prompt/` of this repository. To [copy](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) the mentioned files and folders to the user's `home` folder ON THE SERVER, replace the labels as appropriate in the below commands and execute it from the root folder of this repository.

    scp -r system/home/user/.git_prompt/ {HOST_NAME}:~/
    scp system/home/user/.bash_endurancecode {HOST_NAME}:~/

> + **{HOST_NAME}** : Name given to the server on the SSH Config File
> + **{USERNAME}** : Name of the user account on the server

Run the below command ON THE SERVER to make the included bash script executable.

    chmod + ~/.git_prompt/.git-prompt.sh

The files contained in the folder `~/.git_prompt/` were first presented to my in the course [Learn Enough Git to Be Dangerous](https://www.learnenough.com/git-tutorial/collaborating#sec-advanced_setup) and later in an [Udacity](https://www.udacity.com/) course. The [**Git**](https://git-scm.com) configuration on Ubuntu's recent versions has already the features (branches in the prompt and branches names tab completion) that are implemented by the files [.git-prompt.sh](system/home/user/.git_prompt/.git-prompt.sh) and [.git-completion.bash](system/home/user/.git_prompt/.git-completion.bash). Therefore the current content of [.bash_endurancecode](system/home/user/.bash_endurancecode) is not using those files. If these features aren't being implemented by default, it will be then necessary to edit the file `.bash_endurancecode` in order to make it source the mentioned files. Further investigation on this subject is needed and [this question](https://stackoverflow.com/q/12399002/8352877) at [StackOverflow](https://stackoverflow.com/) seems to be a good place to start.

To complete the process, it's only necessary to edit the file `.bashrc` located in the home folder and add the lines below to the end of the mentioned file.

    # Source the file that enables personal prompt customization and implements custom alias
    # All prompt customization alias implementation must be done in the file sourced below

    #
    if [ -f ~/.bash_endurancecode ]; then
        . ~/.bash_endurancecode
    fi

Start editing the file `.bashrc` with the following command:

    nano ~/.bashrc

After adding the necessary changes, save the file with the command `ctrl + o` and then exit [nano editor](https://www.nano-editor.org/) with the command `ctrl + x`.

Make the changes effective with the following command:

    source ~/.bashrc

This bash customization will be effective every time the user logs in.

### 1.9. Additional folders in the home folder

I like to add three more folders to the server's home folder: one named `Code`, another named `Software` and another named `Templates`. The first one is used to store all my code repositories, the second is used to store all the software packages that I download and install in the system and the third one is used . Those folders can be created with the following command:

    mkdir ~/Code && mkdir ~/Software && mkdir Templates

To check if the new folders were properly created, run the following command:

    ls -la --group-directories-first
