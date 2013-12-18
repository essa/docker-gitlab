FROM ubuntu:12.04 
MAINTAINER Taku Nakajima <takunakajima@gmail.com>

ENV USER lsyncd
ENV PASSWORD lsyncd

# Run upgrades
RUN echo deb http://us.archive.ubuntu.com/ubuntu/ precise universe multiverse >> /etc/apt/sources.list;\
  echo deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe >> /etc/apt/sources.list;\
  echo deb http://security.ubuntu.com/ubuntu precise-security main restricted universe >> /etc/apt/sources.list;\
  echo udev hold | dpkg --set-selections;\
  echo initscripts hold | dpkg --set-selections;\
  echo upstart hold | dpkg --set-selections;\
  apt-get update;\
  apt-get -y upgrade

# Install lsyncd
RUN apt-get install -y lsyncd

# Install ssh

RUN apt-get install -y openssh-server sudo && mkdir /var/run/sshd 

# Add user

RUN useradd $USER && adduser $USER sudo && echo "${USER}:${PASSWORD}" |chpasswd && mkdir /home/$USER && chown -R $USER /home/$USER && chsh -s /bin/bash $USER

# mkdir for mouting data directory 
RUN mkdir -p /mnt/data

EXPOSE 22
CMD /usr/sbin/sshd && lsyncd -nodaemon -rsyncssh /mnt/data lsyncd_target lsyncd_data

