Docker jenkins
===============

Docker compose file for installing [jenkins](https://jenkins.io/) in a docker container
based on [docker jenkins image](https://hub.docker.com/_/jenkins/).

- NOTE! /tmp inside the container (maybe a container only can be 10 GB in default) can become full. It is where temporary files from npm is downloaded and stored during installation

## Installation

Clone repository and cd into app directory

Copy sample.env to .env

`cp sample.env .env`

Open `.env` and add credentials

Run

`./install.sh`

Done!

## Upgrading

All the data needed is in the container `/var/jenkins_home` directory
that is mapped to`./jenkins_app` folder in the application directory.
This data will persist between updates since it is a 
[volume](https://docs.docker.com/engine/tutorials/dockervolumes/)). 

Open `.env` and enter set prefered image version.

Run  

`./install.sh`


## Backing up date
docker cp $VOLUME_ID:/var/jenkins_home

## Install docker

Reference: [install docker](https://docs.docker.com/engine/installation/linux/debian/#prerequisites)

Login as root to your docker conatiner
```
docker exec -it -u root jenkins /bin/bash 
```

Then install docker 
```
apt-get update
apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce
```

Then add jenkins to docker group such that jenkins can manage docker

```
usermod -aG docker jenkins
```

Ensure that the `docker-compose.yml` file maps the host docker 
socked to the container.

```
 volumes:
   - "/var/run/docker.sock:/var/run/docker.sock"
```

Finally restart your jenkins container to ensurra that usermod will take effect
```
docker-compose restart
```

Done!

## Install docker compose

Reference: [install docker compose](https://docs.docker.com/compose/install/)

Login as root to your docker conatiner
```
docker exec -it -u root jenkins /bin/bash 
```
Then run
```
curl -L "https://github.com/docker/compose/releases/download/1.14.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
Make docker-compose executable
```
chmod +x /usr/local/bin/docker-compose
```



