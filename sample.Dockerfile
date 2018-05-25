# only lts is supported on dockerhub https://hub.docker.com/r/jenkins/jenkins
FROM jenkins/jenkins:{version-jenkins}

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

#RUN /usr/local/bin/install-plugins.sh build-timeout credentials

USER root

# Add credentials to askpass file (force instalation of packages fetch from github)
RUN apt-get update \
    && apt-get install -y \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg2 \
       software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" \
    &&  apt-get update \
    && apt-get install -y docker-ce \ 
    &&  usermod -aG docker jenkins \
    && curl -L "https://github.com/docker/compose/releases/download/{version-docker-compose}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

USER jenkins
