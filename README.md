Docker jenkins
===============

Docker compose file for installing [jenkins](https://jenkins.io/) in a docker container
based on [docker jenkins image](https://hub.docker.com/_/jenkins/).

## Installation

Clone repository and cd into app directory

Run `mkdir data && chmod 777 data`

Run `cp sample.docker-compose.yml doker-compose.yml` and add your 
domain/subdomain to VIRTUAL_HOST

Run `docker-compose up -d` 

Open jenkins and follow instructions

Done :-)

## Upgrading

All the data needed is in the container`/var/jenkins_home` directory
that is mapped to`./jenkins_app` folder in the aplication dorectory.
This data will persist between updates since it is a 
[volume](https://docs.docker.com/engine/tutorials/dockervolumes/)). 

Open `docker-compose.yml` and enter new vresion forimgae.

Run  

## Backing up date
docker cp $VOLUME_ID:/var/jenkins_home
