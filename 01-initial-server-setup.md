# Server setup guide

## Introduction

This file contains the
**[Initial server setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04)**
section of [my personal guide to set up an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide).
The introduction to this guide as well as its full *Table of Contents* can be found on the
[README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

## Table of Contents

1. [Initial Setup](#1-initial-server-setup)
    1. [Deploy the server](#11-deploy-the-server)
    2. [System update](#12-system-update)
    3. [Create a non-root user](#13-create-a-non-root-user)
    4. [Setup SSH key-based login](#14-setup-ssh-key-based-login)
    5. [Test the user SSH keys and secure the SSH server](#15-test-the-user-ssh-keys-and-secure-the-ssh-server)
    6. [Install and configure Fail2Ban](#16-install-and-configure-fail2ban)
    7. [Set up the firewall](#17-set-up-the-firewall)
    8. [Git](#18-git)
    9. [Bash prompt customization](#19-bash-prompt-customization)
    10. [Additional folders in the home folder](#110-additional-folders-in-the-home-folder)

## 1. Initial server setup

### 1.1. Deploy the server

Choose the cloud provider and deploy the server with the latest [Ubuntu LTS version](https://ubuntu.com/about/release-cycle).

For security reasons, disable password login and set [SSH Keys](https://www.atlassian.com/git/tutorials/git-ssh) as the only login method.

### 1.2. System update

Newly deployed servers only have a `root` account set, therefore, the first login on the server must be done with this account. To update the server's system software, login with the provided user (normally `root`) and execute the following commands:

    apt update
    apt full-upgrade

### 1.3. Create a non-root user

As it's more secure to login with a user other than the `root` user, replace the ***{LABEL}*** in the below command as appropriate and use it to [create a new user](https://linuxize.com/post/how-to-add-and-delete-users-on-ubuntu-20-04/). When prompted, provide the new user's password (providing an answer to the subsequent questions is optional).

    sudo adduser {USERNAME}

> **Label Definition**
>
> + **{USERNAME}** : Name of the new user account

To enable the newly created user to perform administrative tasks, replace the ***{LABEL}*** in the below command as appropriate in the below command and use it to [add the user to the `sudo` group](https://linuxize.com/post/how-to-add-user-to-group-in-linux/).

    sudo usermod -aG sudo {USERNAME}

> **Label Definition**
>
> + **{USERNAME}** : Name of the user account to be added to the `sudo` group

Replace the ***{LABEL}*** in the below command as appropriate and use it to login as the newly created user.

    su - {USERNAME}

> **Label Definition**
>
> + **{USERNAME}** : Name of the user account

Then check the output of the following command:

    sudo -l

To double check if the user has root privileges, perform a system update with the following commands:

    sudo apt update
    sudo apt full-upgrade

### 1.4. Setup SSH key-based login

As the server was deployed to only accept
[SSH key-based login](https://linuxize.com/post/how-to-setup-passwordless-ssh-login/),
it is necessary to [enable the SSH key-based login](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-22-04)
for the created user.

If not already logged as the new user, replace the placeholders in the below command as appropriate
and execute it to log in with the correct user account.

```shell
su - {USERNAME}
```

> **Placeholder Definition**
>
> + **{USERNAME}** : Name of the user account on the server

Make sure that the user's `~/.ssh` directory is created with the following command:

```shell
mkdir -p ~/.ssh
```

Add the client's public SSH Key to the server's `authorized_keys` file (**ON THE SERVER** user's
`~/.ssh` directory), replace the placeholders in the below command as appropriate and execute it
on the server.

```shell
echo {SSH_KEY} >> ~/.ssh/authorized_keys
```

> **Placeholder Definition**
>
> + **{SSH_KEY}** : The public SSH key of the client machine obtained executing the command
>   `cat ~/.ssh/id_rsa.pub` o**ON THE CLIENT** machine

To set the proper permissions on the created directory and files, execute the following commands:

```shell
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown -R "${USER}":"${USER}" ~/.ssh
```

After setting the `~/.ssh` folder for the created user, log back with the root user with the
following command:

```shell
exit
```

To logout from the server, execute the following command:

```shell
exit
```

### 1.5. Test the user SSH keys and secure the SSH server

To make the login in the server process easier,
[set the SSH Config File](https://linuxize.com/post/using-the-ssh-config-file/). **ON THE CLIENT**
machine use the [*nano text editor*](https://www.nano-editor.org/) to edit (or create) 
the SSH Config File with the following command:

```shell
nano ~/.ssh/config
```

Then, replace the placeholders in the below snippet as appropriate and paste it on a new line
of the `~/.ssh/config` file.

```text
host    {HOST_NAME}
        hostname {SERVER_IP_ADDRESS}
        User {USERNAME}
```

> **Placeholder Definition**
>
> + **{HOST_NAME}** : Name given to the server
> + **{SERVER_IP_ADDRESS}** : IP Address of the server
> + **{USERNAME}** : Name of the user account on the server

Save the changes with the command `CTRL + O` and the exit teh text editor
with the command `CTRL + X`.

Replace the placeholder in the below command as appropriate and then execute it to try to log in
on the server.

```shell
ssh {HOST_NAME}
```

> **Placeholder Definition**
>
> + **{HOST_NAME}** : Name given to the server and used on the `~/.ssh/config` file

If the login on the server was successful, it's now time to enhance the SSH server security.

> **Critical Note:** Do not close your current SSH session while making changes described in the
> next steps. Open a second terminal window and use it to make the changes on the SSH server
> configuration. After every restart of the SSH service, terminate the connection and try to connect
> to the server. If you make a mistake, you will be locked out, and the open session in the first
> terminal window is your only way to fix it.

Backup the SSH configuration file with the following command:

```shell
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

Use the [*nano text editor*](https://www.nano-editor.org/) to edit the SSH configuration file
`/etc/ssh/sshd_config` with the following command:

```shell
sudo nano /etc/ssh/sshd_config
```

Then, use the command `CTRL + W` to search for each directive shown on the below snippet (those
directives will be in different sections of the file) and if necessary modify it accordingly:

```text
LoginGraceTime 30s
PermitRootLogin no
StrictModes yes
MaxAuthTries 3
MaxSessions 3

PasswordAuthentication no
PermitEmptyPasswords no

KbdInteractiveAuthentication no

UsePAM yes
```

The directive `KbdInteractiveAuthentication`
[replaced the directive](https://askubuntu.com/a/1403850) `ChallengeResponseAuthentication`. The
directive `PermitRootLogin no will disable
[SSH root login](https://www.tecmint.com/disable-or-enable-ssh-root-login-and-limit-ssh-access-in-linux/)
which will enhance security because any hacker can try to brute force the root password and gain
access to the system.

Save the modifications with the command `CTRL + O` and then exit the text editor
with the command `CTRL + X`.

Validate the SSH configuration file syntax with the following command:

```shell
sudo sshd -t
```

If the previous command return no output, make the modifications effective by restarting
the SSH service with the following commands:

```shell
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket
sudo systemctl restart ssh
```

Logout the server with the following command:

```shell
exit
```

And then, to verify that everything is still working perfectly, log in back on the server:

```shell
ssh {HOST_NAME}
```

If you can't log in back on the server, use the open session in the first terminal window to
revert the changes made to the SSH configuration file by restoring the backup file with the
following command:

```shell
sudo mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
```

Make the modifications effective by restarting the SSH service with the following commands:

```shell
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket
sudo systemctl restart ssh
```

Try to log in back on the server again, in the second terminal window. If the login on the server
was successful (or is now successful), everything is correctly configured, and you should proceed
enhancing the server security by disabling Forwarding and Tunneling and configuring Idle Timeouts.

Backup again the SSH configuration file with the following command:

```shell
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

Use the [*nano text editor*](https://www.nano-editor.org/) to edit the SSH configuration file
`/etc/ssh/sshd_config` with the following command:

```shell
sudo nano /etc/ssh/sshd_config
```

Then, use the command `CTRL + W` to search for each directive shown on the below snippet
and if necessary modify it accordingly:

```text
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no

ClientAliveInterval 300
ClientAliveCountMax 2
```

> **Important Note**: Disabling `AllowTcpForwarding` will prevent the use of SSH Tunneling.
> Therefore, if you need to use SSH Tunneling, do not disable this directive. Also, be aware
> that some applications (like `ssh-agent` and `gpg-agent`) may require `AllowAgentForwarding`
> to be enabled to function correctly.

Save the modifications with the command `CTRL + O` and then exit the text editor
with the command `CTRL + X`.

Validate the SSH configuration file syntax with the following command:

```shell
sudo sshd -t
```

If the previous command return no output, make the modifications effective by restarting
the SSH service with the following commands:

```shell
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket
sudo systemctl restart ssh
```

Logout the server with the following command:

```shell
exit
```

Verify that everything is still working perfectly by logging in on the server:

```shell
ssh {HOST_NAME}
```

If the login on the server was successful, everything is correctly configured, and you should
proceed enhancing the server security by restricting the allowed users.

Backup again the SSH configuration file with the following command:

```shell
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

Use the [*nano text editor*](https://www.nano-editor.org/) to edit the SSH configuration file
`/etc/ssh/sshd_config` with the following command:

```shell
sudo nano /etc/ssh/sshd_config
```

Then, use the command `CTRL + W` to search for the `AllowUsers` directive and, after replacing the
placeholder in the below snippet as appropriate, modify it accordingly. If the directive does
not exist, add it above the `LoginGraceTime` directive.

```text
AllowUsers {USERNAME}
```

> **Placeholder Definition**
>
> + **{HOST_NAME}** : Name given to the server and used on the `~/.ssh/config` file

Save the modifications with the command `CTRL + O` and then exit the text editor
with the command `CTRL + X`.

Validate the SSH configuration file syntax with the following command:

```shell
sudo sshd -t
```

If the previous command return no output, make the modifications effective by restarting
the SSH service with the following commands:

```shell
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket
sudo systemctl restart ssh
```

Logout the server with the following command:

```shell
exit
```

And then, to verify that everything is still working perfectly, log in back on the server:

```shell
ssh {HOST_NAME}
```

If the login on the server was successful, everything is correctly configured, and you should
proceed enhancing the server security by restricting the encryption algorithms allowed 
for SSH connections to only the most secure ones.

Backup again the SSH configuration file with the following command:

```shell
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

Use the [*nano text editor*](https://www.nano-editor.org/) to edit the SSH configuration file
`/etc/ssh/sshd_config` with the following command:

```shell
sudo nano /etc/ssh/sshd_config
```

Navigate to the end of the file and add the below snippet:

```text
# Restricting the encryption algorithms to only the most secure ones
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
```

Save the modifications with the command `CTRL + O` and then exit the text editor
with the command `CTRL + X`.

Validate the SSH configuration file syntax with the following command:

```shell
sudo sshd -t
```

If the previous command return no output, make the modifications effective by restarting
the SSH service with the following commands:

```shell
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket
sudo systemctl restart ssh
```

Logout the server with the following command:

```shell
exit
```

And then, to verify that everything is still working perfectly, log in back on the server:

```shell
ssh {HOST_NAME}
```

If the login on the server was successful, everything is correctly configured, and you can delete
the backup file created during the process with the following command:

```shell
sudo rm /etc/ssh/sshd_config.bak
```

### 1.6. Install and configure Fail2Ban

To enhance the server security, install and configure [**Fail2Ban**](https://www.fail2ban.org/) 
with the following command:

```shell
sudo apt update && sudo apt install fail2ban
```

> **Critical Note:** Do not close your current SSH session while making changes described in the
> next steps. Open a second terminal window and use it to make the
> [**Fail2Ban**](https://www.fail2ban.org/) configuration. After finishing the configuration,
> terminate the connection and try to connect to the server. If you make a mistake, you will be
> locked out, and the open session in the first terminal window is your only way to fix it.

[**Fail2Ban**](https://www.fail2ban.org/) reads its default configuration from `jail.conf` but you
should never edit this file directly because the system updates will overwrite it. Instead, create
a copy called `jail.local`, which overrides the defaults.

Use the [*nano text editor*](https://www.nano-editor.org/) to create and edit the file
`/etc/fail2ban/jail.local` with the following command:

```shell
sudo nano /etc/fail2ban/jail.local
```

Paste the below configuration snippet into the file.

```text
[DEFAULT]
# Whitelist your own IP address if it is static.
# If your IP changes often, leave this commented out.
# ignoreip = 127.0.0.1/8 ::1 123.123.123.123

# "bantime": How long an IP is banned (10 minutes)
bantime  = 10m

# "findtime": The window of time to count failures (10 minutes)
# If a user fails X times within this window, they get banned.
findtime  = 10m

# "maxretry": Number of failures allowed before banning
maxretry = 5

[sshd]
enabled = true

# Ubuntu uses systemd/journald logs. 
# This ensures Fail2Ban reads the logs correctly.
backend = systemd

# The port to protect.
port    = ssh

# "mode": aggressive catches more sophisticated failure patterns
# (e.g., "Connection refused", "Auth fail", etc.)
mode    = aggressive
```

Save the file with the command `CTRL + O` and then exit the text editor with the command `CTRL + X`.

Now that the configuration is in place, start the Fail2Ban service and ensure it starts
automatically on server reboot:

```shell
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
```

To verify that the service is running, execute the following command:

```shell
sudo systemctl status fail2ban
```
You should see output indicating that the service is active and running. To check which jails are
currently active, execute the following command:

```shell
sudo fail2ban-client status
```
You should see `sshd` listed among the active jails.

### 1.7. Set up the firewall

The [**ufw**](https://launchpad.net/ufw) firewall is installed by default on Ubuntu. Confirm that it is installed with the
following command:

    which ufw

If [**ufw**](https://launchpad.net/ufw) isn't installed, solve the problem with the following
commands:

    sudo apt update
    sudo apt install ufw

Check the status of the [**ufw**](https://launchpad.net/ufw) service with the following command:

    sudo ufw status verbose

#### 1.7.1. Enable IPV6

Start to [setup **ufw**](https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-ubuntu-20-04/), by making sure that [IPV6 is enable](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-1-using-ipv6-with-ufw-optional). Do it running the following command:

    cat /etc/default/ufw | grep IPV6

If the output of the above command shows the below snippet, IPV6 is already enabled.

    IPV6=yes

If IPV6 is not yet enable, open the file `/etc/default/ufw` with the [*nano text editor*](https://www.nano-editor.org/) executing the following command:

    sudo nano /etc/default/ufw

Make the necessary modifications, save it with the command `CTRL + O` and then exit the [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`.

#### 1.7.2. Setup the default policies

Setup [**ufw**](https://launchpad.net/ufw)'s [default policies](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-2-setting-up-default-policies) with the following commands:

    sudo ufw default deny incoming
    sudo ufw default allow outgoing

#### 1.7.3. Allow SSH Connections

[Allow SSH Connections](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-3-allowing-ssh-connections) with the following command:

    sudo ufw allow ssh

#### 1.6.4. Enable

[Enable **ufw**](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04#step-4-enabling-ufw) with the following command:

    sudo ufw enable

There will be a warning stating that this command may disrupt existing SSH connections but, as the command that allows SSH connections has already been executed, it should be fine to continue. Therefore, it's safe to respond to the prompt with `Y` and enable [**ufw**](https://launchpad.net/ufw).

### 1.8. Git

To check if [**Git**](https://git-scm.com) is already installed on the server, execute the following command:

    which git && git --version

If necessary, [install **Git**](https://help.ubuntu.com/lts/serverguide/git.html), with the following command:

    sudo apt update && sudo apt install git

Replace the ***{LABELS}*** in the below command as appropriate and use it to set [**Git**'s global configuration](https://www.learnenough.com/git-tutorial#sec-installation_and_setup). Instructions for a more detailed **Git** global configuration can be found in [Git's Official Documentation](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).

    git config --global core.editor nano
    git config --global user.name "{USER}"
    git config --global user.email {EMAIL}
    git config --global pull.rebase true
    git config --list

> **Labels Definition**
>
> + **{USER}** : Name of the **Git** user
> + **{EMAIL}** : Public e-mail of the **Git** user

### 1.9. Bash prompt customization

All the files necessary to customize the bash environment, are stored at the folder `root/home/user/.bash_USER` of the [system-configuration-files](https://github.com/EnduranceCode/system-configuration-files) repository. The easiest way to use the files on the referred repository is to start by cloning it to your local machine. Do it with the execution of the following command:

    git clone https://github.com/EnduranceCode/system-configuration-files.git

To [copy](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) the mentioned folder (and files) to the **SERVER** user's `home` folder, replace the ***{LABELS}*** in the below commands as appropriate and execute it, **ON A CLIENT MACHINE**.

    scp -r {SYSTEM_CONFIGURATION_FILES_REPOSITORY_ROOT_FOLDER}/root/home/user/.bash_USER {HOST_NAME}:~/

> **Label Definition**
>
> + **{SYSTEM_CONFIGURATION_FILES_REPOSITORY_ROOT_FOLDER}** : Path to the system-configuration-files repository root folder
> + **{HOST_NAME}** : Name given to the server on the SSH Config File

The files contained in the folder `root/home/user/.bash_USER/bash_git/` of the [system-configuration-files](https://github.com/EnduranceCode/system-configuration-files) repository, were first presented to me in the course [Learn Enough Git to Be Dangerous](https://www.learnenough.com/git-tutorial/collaborating#sec-advanced_setup) and later in an [Udacity](https://www.udacity.com/) course. The most recent [**Git**](https://git-scm.com) versions (on Ubuntu) already have the features (branches in the prompt and branches names tab completion) that are implemented by the files [.git-prompt.sh](https://github.com/EnduranceCode/system-configuration-files/blob/master/root/home/user/.bash_USER/bash_git/git-prompt.sh) and [git-completion.bash](https://github.com/EnduranceCode/system-configuration-files/blob/master/root/home/user/.bash_USER/bash_git/git-completion.bash). Therefore the current content of [bash_git.sh](https://github.com/EnduranceCode/system-configuration-files/blob/master/root/home/user/.bash_USER/bash_git.sh) is not using those files.

To be able to use the files copied in the previous step for the bash environment customization, execute, **ON THE SERVER**, the following commands:

    mv ~/.bash_USER ~/.bash_"${USER}"
    mv ~/.bash_"${USER}"/bash_USER.sh ~/.bash_"${USER}"/bash_"${USER}".sh
    chown -R "${USER}":"${USER}" ~/.bash_"${USER}"
    chmod -R 700 ~/.bash_"${USER}"

To complete the process, it's necessary to edit the file `.bashrc` located in the home folder and add the lines below to the end of the mentioned file.

    # Source the file that enables personal prompt customization and implements custom alias
    # All prompt customization alias implementation must be done in the file sourced below
    #
    if [ -f ~/.bash_"${USER}"/bash_"${USER}".sh ]; then
        . ~/.bash_"${USER}"/bash_"${USER}".sh
    fi

Open the file `.bashrc` with [*nano text editor*](https://www.nano-editor.org/) executing the following command:

    nano ~/.bashrc

After adding the necessary modifications, save the file with the command `CTRL + O` and then exit [*nano text editor*](https://www.nano-editor.org/) with the command `CTRL + X`.

Make the changes effective with the following command:

    source ~/.bashrc

This bash customization will be effective every time the user logs in.

### 1.10. Additional folders in the home folder

I like to add three more folders to the server's home folder: one named `Code`, another named `Software` and another named `Templates`. The first one is used to store all my code repositories, the second is used to store all the software packages that I download and install in the system and the third one is used to store any template needed for the server management. Those folders can be created with the following command:

    mkdir -p ~/code && mkdir -p ~/prod-files && mkdir -p ~/software && mkdir -p ~/templates

To check if the new folders were properly created, execute the following command:

    ls -la --group-directories-first
