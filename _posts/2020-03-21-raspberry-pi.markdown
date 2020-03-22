---
layout: post
title: "🍇 Raspberry Pi"
date: 2020-03-21
---

My home network configuration is available on my [gitlab account](https://gitlab.com/goldenson/raspberry-pi).

## Basic config

1. Flash your SD card with the latest [raspian image](https://www.raspberrypi.org/downloads/raspbian/).
2. Add an empty [ssh file](https://www.raspberrypi.org/documentation/remote-access/ssh/) at the root of your SD card.
3. Find your raspberry's ip address on your network with `arp -a`
4. Ssh to your raspberry and [add your own user](https://www.raspberrypi.org/documentation/linux/usage/users.md)
5. Add your `ssh` access with `ssh-copy-id goldenson@192.168.0.X`
6. Install some dependencies

```bash
$ sudo apt-get update && sudo apt-get upgrade
$ apt-get install git vim
```

### Install Docker

```bash
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
$ sudo usermod -aG docker goldenson
$ docker version
$ docker info
$ docker run hello-world
$ sudo systemctl enable docker
$ sudo systemctl start docker
```

### Install docker-compose

```bash
$ sudo apt install -y python3-pip libffi-dev
$ sudo pip3 install docker-compose
```

### Using systemd

This is a technique to ensure our containers are getting spinned up at boot time in case our rapsberry crashes.

- Run `./install.sh`

> [Add a service](https://www.raspberrypi.org/documentation/linux/usage/systemd.md)


## [Pi-hole](https://pi-hole.net/)

A network-wide ad blocking, you can access it at the following ip address: `http://192.168.0.X/admin`

- Change your password: `docker exec -it pihole pihole -a -p`
- [pi-hole image](https://hub.docker.com/r/pihole/pihole/)


## [Portainer](https://www.portainer.io/)

A docker management web ui that helps you to visualize your container.

- [portainer image](https://hub.docker.com/r/portainer/portainer/)

### Links

- [Flashing SD card](https://www.balena.io/etcher/)
- [Tutorial](https://homenetworkguy.com/how-to/install-pihole-on-raspberry-pi-with-docker-and-portainer/)
