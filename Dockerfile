FROM ubuntu:12.04
MAINTAINER Taku Nakajima <takunakajima@gmail.com>

ENV RubyVersion 2.1.0
ENV GitlabBranch v6.4.3
ENV GitlabShellBranch v1.8.0

# Run upgrades
RUN echo deb http://us.archive.ubuntu.com/ubuntu/ precise universe multiverse >> /etc/apt/sources.list;\
  echo deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe >> /etc/apt/sources.list;\
  echo deb http://security.ubuntu.com/ubuntu precise-security main restricted universe >> /etc/apt/sources.list;\
  echo udev hold | dpkg --set-selections;\
  echo initscripts hold | dpkg --set-selections;\
  echo upstart hold | dpkg --set-selections;\
  apt-get update;\
  apt-get -y upgrade 

# Install dependencies
RUN apt-get update && apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev sudo python python-docutils python-software-properties nginx logrotate postfix mysql-client libmysqlclient-dev

# Install Git
RUN add-apt-repository -y ppa:git-core/ppa;\
  apt-get update;\
  apt-get -y install git

# Install Ruby
RUN mkdir /tmp/ruby;\
  cd /tmp/ruby;\
  curl ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-${RubyVersion}.tar.gz | tar xz;\
  cd ruby-${RubyVersion};\
  chmod +x configure;\
  ./configure --disable-install-rdoc;\
  make;\
  make install;\
  gem install bundler --no-ri --no-rdoc

# Create Git user
RUN adduser --disabled-login --gecos 'GitLab' git

# Install GitLab Shell
RUN cd /home/git;\
  su git -c "git clone https://github.com/gitlabhq/gitlab-shell.git";\
  cd gitlab-shell;\
  su git -c "git checkout ${GitlabShellBranch}";\
  su git -c "cp config.yml.example config.yml";\
  sed -i -e 's/localhost/127.0.0.1/g' config.yml;\
  su git -c "./bin/install"

# Install GitLab

RUN cd /home/git;\
  su git -c "git clone https://github.com/gitlabhq/gitlabhq.git gitlab";\
  cd /home/git/gitlab;\
  su git -c "git checkout ${GitlabBranch}"

# Misc configuration stuff
RUN cd /home/git/gitlab;\
  chown -R git tmp/;\
  chown -R git log/;\
  chmod -R u+rwX log/;\
  chmod -R u+rwX tmp/;\
  su git -c "mkdir /home/git/gitlab-satellites";\
  su git -c "mkdir tmp/pids/";\
  su git -c "mkdir tmp/sockets/";\
  chmod -R u+rwX tmp/pids/;\
  chmod -R u+rwX tmp/sockets/;\
  su git -c "mkdir public/uploads";\
  chmod -R u+rwX public/uploads;\
  su git -c "cp config/unicorn.rb.example config/unicorn.rb";\
  su git -c "cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb";\
  su git -c "git config --global user.name 'GitLab'";\
  su git -c "git config --global user.email 'gitlab@localhost'";\
  su git -c "git config --global core.autocrlf input"

RUN cd /home/git/gitlab;\
  su git -c "bundle install --deployment --without development test postgres aws"

# Install init scripts
RUN cd /home/git/gitlab;\
  cp lib/support/init.d/gitlab /etc/init.d/gitlab;\
  chmod +x /etc/init.d/gitlab;\
  update-rc.d gitlab defaults 21;\
  cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab

# Prepare for mouting data directories
RUN rm -r /home/git/gitlab/tmp && ln -s /srv/gitlab/data/tmp /home/git/gitlab/tmp  && \
    rm -r /home/git/gitlab/log && ln -s /srv/gitlab/data/log /home/git/gitlab/log  && \
    rm -r /home/git/.ssh && ln -s /srv/gitlab/data/ssh /home/git/.ssh  && \
    sed -i -e 's/\/home\/git\/repositories/\/srv\/gitlab\/data\/repositories/g' /home/git/gitlab-shell/config.yml

# Install additional tools and setting for maintainance and debug with ssh-session
RUN apt-get install -y vim w3m wget zsh tmux lv && adduser git sudo 

EXPOSE 80
EXPOSE 22

# expected to mount this directory
CMD ["/srv/gitlab/scripts/start.sh"]



