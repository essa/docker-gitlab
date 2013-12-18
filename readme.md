# GitLab Docker Build Script

This Dockerfile will create a new Docker container running GitLab 6.3 on Ubuntu 13.10 based on crashsystems/gitlab-docker.

## Installation

Follow these instructions to download or build GitLab.

### Step 0: Install Docker

[Follow these instructions](http://www.docker.io/gettingstarted/#h_installation) to get Docker running on your server.

### Step 1: Pull Or Build GitLab

With Docker installed and running, do one of the following to obtain GitLab.

**Pull From Docker Index:**

    docker pull crashsystems/gitlab-docker

**Build It Yourself**

    git clone https://github.com/crashsystems/gitlab-docker.git
    cd gitlab-docker
    docker build -t gitlab .

Note that since GitLab has a large number of dependencies, both pulling from the index or running the build process will take a while, although pulling should be somewhat faster.

### Step 2: Configure GitLab

If you obtained the image via docker pull and therefore didn't clone the GitHub repo, go ahead and do so at this time. The config/ folder of the repository contains configuration files you will need to edit before creating a new container instance.

* **gitlab.yml**: Change the host field to match the hostname for your GitLab instance. Under *Advanced settings* in the config file, change the *ssh_port* setting for GitLab Shell to the port on the Docker host that's mapped to port 22 for this container. If you are using a non-standard port and don't do this, you won't be able to commit changes through a git/SSH url. Also, make any additional changes, such as LDAP configs etc, at this time.
* **database.yml**: In the *production* section, set a good password for the gitlab MySQL password.
* **nginx**: Replace YOUR_SERVER_FQDN with the hostname for your GitLab instance. Also, this file can be used to configure other things, such as SSL/TLS configurations.

In addition, set the mysqlRoot variable in firstrun.sh to a good password for your MySQL root user.

### Step 3: Create A New Container Instance

This build makes use of Docker's ability to map host directories to directories inside a container. It does this so that a user's custom configuration can be injected into the container at first start. In addition, since the data is stored outside the container, it allows a user to put the folder on faster storage such as an SSD for higher performance.

To create the container instance, run the following:

    cd /path/to/gitlab-docker
    chmod +x firstrun.sh
    chmod +x start.sh

Next, run this if you pulled the image from the Docker index:

    docker run -d -v /path/to/gitlab-docker:/srv/gitlab -name gitlab crashsystems/gitlab-docker

Or this if you built it yourself:

    docker run -d -v /path/to/gitlab-docker:/srv/gitlab -name gitlab gitlab

*/path/to/gitlab-docker* represents the folder created by the git clone on the Docker host, and will contain the GitLab instance's data. Make sure to move it to your desired location before running the container. Also, the first boot of the container will take a bit longer, as the firstrun.sh script will be invoked to perform various initialization tasks.

##### Default username and password
GitLab creates an admin account during setup. You can use it to log in:

    admin@local.host
    5iveL!fe

