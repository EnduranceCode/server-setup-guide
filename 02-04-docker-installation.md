# Server setup guide

## Introduction

This file contains the **[Docker installation](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)** section of [my personal guide to setup an Ubuntu server](https://github.com/EnduranceCode/server-setup-guide). The introduction to this guide as well as its full *Table of Contents* can be found on the [README.md](./README.md) file of this repository. The *Table of Contents* of this section is listed below.

2. Software Installation

    4. [Docker installation](./02-04-docker-installation.md)
        1. [Install Docker](#241-install-docker)

## 2.4. Docker installation

### 2.4.1. Install Docker

Install the required dependencies with the following commands:

    sudo apt install apt-transport-https ca-certificates curl software-properties-common

Then, add [**Docker**](https://www.docker.com/)'s official GPG key with the following commands:

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

To add the [**Docker**](https://www.docker.com/)'s stable repository, execute the following command:

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

Install the latest version of the [**Docker**](https://www.docker.com/)'s packages with the following commands:

    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

By default, the `docker` command can only be executed by the `root` user or by a user in the `docker` group, which is automatically created during the [**Docker**](https://www.docker.com/)'s installation process. Read the output of the upcoming command to check if your user belongs to the `docker` group.

    goups

 If your user doesn't belong to the `docker` group, add it with the following command:

    sudo usermod -aG docker $USER

Log out and log back in so that your group membership is re-evaluated, or run the following command to activate the changes to groups:

    newgrp docker

Verify that your user was added to the `docker` group by reading the output of the `goups`.

Check the installed versions using the following commands

    docker --version
    dockerd --version
    docker compose version

On [Ubuntu](https://ubuntu.com/), the [**Docker**](https://www.docker.com/) service starts on boot by default, therefore, it won't be necessary to enable it. To verify that `docker` and `containerd` were started by *systemd*, run the following commands:

    sudo systemctl status docker.service
    sudo systemctl status containerd.service

To view system-wide information about Docker, execute the following command:

    docker info

To check whether you can access and download images from Docker Hub, execute the following command:

    docker run hello-world

The output of the previous command should state "that your installation appears to be working correctly".

To get the data about the hello-world container, check the output of the following command:

    docker ps -a

To remove the hello-world container, replace the ***{LABEL}*** in the below command as appropriate and execute it.

      docker rm {CONTAINER_ID}

> **Label Definition**
>
> + **{CONTAINER_ID}** : The container ID that can be obtained from the output of the command `docker ps -a`

The output of the command `docker ps -a` should no longer show the hello-world container.

To see the images that have been downloaded to your computer, execute the following command:

    docker images

The output of the above command should display the hello-world image. To remove the hello-world image, replace the ***{LABEL}*** in the below command as appropriate and execute it.

    docker rmi {IMAGE_ID}

> **Label Definition**
>
> + **{IMAGE_ID}** : The image ID that can be obtained from the output of the command `docker images`

After the execution of the above command, the output of the command `docker images` should no longer show the hello-world image.
