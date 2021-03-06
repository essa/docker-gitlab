# GitLab Docker Build Script

This Dockerfile will create a new Docker container running GitLab 6.3 based on https://github.com/crashsystems/gitlab-docker .

And these scripts will run three Docker containers.

* nginx for front end
* lsyncd for copying repositories
* gitlab

With these containers and https://github.com/essa/docker-mysql-repl, you can run a gitlab with semi-realtime backup.

## Installation

Follow these instructions to download or build GitLab.

### Step 0: Install Docker and MySQL server

[Follow these instructions](http://www.docker.io/gettingstarted/#h_installation) to get Docker running on your server.

And install a MySQL server. I recomend https://github.com/essa/docker-mysql-repl.

### Step 1: setup config files

Run this script.

    ./setup_config.sh

edit "env" for your environment, and run it again.

    ./setup_config.sh

config/* are generated by this script. Check them and edit if you want to.

### Step 2: build Docker containers

    sudo docker build -t gitlab .
    (cd docker-nginx-front; sudo docker build -t nginx .)
    (cd docker-lsyncd; sudo docker build -t lsyncd .)

Note that since GitLab has a large number of dependencies, running the build process will take a while.

### Step 3: start nginx-front and lsyncd

     sudo docker-nginx-front/start_nginx.sh

You can add another virtual hosts to docker-nginx-front/sites-enabled

     sudo docker-lsyncd/start_lsyncd.sh `pwd`/data

### Step 3: Create A New Container Instance

To create the container instance, run the following:

    chmod +x scripts/firstrun.sh
    sudo ./start_docker_gitlab.sh

Note: scripts/firstrun.sh will initialize DB and chmod -x itself. If you want to run it again, do "chmod +x scripts/firstrun.sh" and run the container.

##### Default username and password
GitLab creates an admin account during setup. You can use it to log in:

    admin@local.host
    5iveL!fe


