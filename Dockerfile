# Get specific node version (less risk)
FROM jenkins:2.60.2

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
    && curl -L "https://github.com/docker/compose/releases/download/1.14.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

USER jenkins
