#!/bin/bash

if [ -f .env ]; then

      export $(cat .env | grep -v ^# | xargs)

   else

      echo "Missing .env file please copy sample.env -> .env and edit .env"
      exit

fi

echo "Will install jenkins $VERSION_JENKINS"
echo "docker-compose $VERSION_DOCKER_COMPOSE will be installed in container" 
read -p "Press enter to continue"

echo "Copying sample.docker-compose.yml -> docker-compose.yml"
cp sample.docker-compose.yml docker-compose.yml

echo "Adding variables to docker-compose.yml"
sed -i "s/{version}/$VERSION_JENKINS/g" docker-compose.yml
sed -i "s/{virtual-host}/$VIRTUAL_HOST/g" docker-compose.yml

echo "Copying sample.Dockerfile -> Dockerfile"
cp sample.Dockerfile Dockerfile

echo "Adding variables to Dockerfile"
sed -i "s/{version-jenkins}/$VERSION_JENKINS/g" Dockerfile
sed -i "s/{version-docker-compose}/$VERSION_DOCKER_COMPOSE/g" Dockerfile


read -p "Remove previous jenkins container(Y/n)?" choice
case "$choice" in
      y|Y ) echo "Removing... " && docker-compose rm -f;;
      n|N ) echo "Keep keeping container";;
      * ) echo "Removing... " && docker-compose rm -f;;
esac

read -p "Rebuild docker (Y/n)?" choice
case "$choice" in
      y|Y ) echo "Building... " && docker-compose build;;
      n|N ) echo "No rebuild";;
      * ) echo "Building... " && docker-compose build;;
esac

echo "Installing container"
docker-compose up -d


