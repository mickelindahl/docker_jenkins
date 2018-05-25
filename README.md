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

Run `cp sample.docker-compose.yml doker-compose.yml` and add your 
domain/subdomain to VIRTUAL_HOST

Done!

## Configure jenkins

### Use pipline ssh-agent

Step 1, generate public and private key on build server as user jenkins

Run `cat .ssh/id_rsa.pub`

Step 2, create `authorized_keys` in `.ssh/` paste the pub file contents. Then make sure  
`authorized_keys` has permission 644 and `.ssh/` has 700

Step 3, configure Jenkins
OBS it is contetn of **id_rsa** not **id_rsa.pub** now
* In the jenkins web control panel, nagivate to "Credentials" -> "System" -> "Global credentials (unrestricted) -> Add credentials" -> "SSH username with private key"
* Enter username
* Add **private key**
* Enter `ID`, this will be used with the plugin as
```
sshagent(credentials: ['{ID}']) {...}

```
* save

### Bourne shell (sh) be aware
You may be interested in the fact that the ability to source a script with arguments is a bashism. In sh or dash your main.sh will not echo anything because the arguments to the sourced script are ignored and $1 will refer to the argument to main.sh.

This apllies since sh is the standard shell in jenkins. You can change the stardar shell under Manage Jenins -> Configure system -> Shell -> Shell executable

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



