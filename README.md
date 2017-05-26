# Docker
Docker Practice 

1) Setup the repo:
Link: https://docs.docker.com/engine/installation/linux/centos/#install-docker

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

2) Install Docker:
sudo yum makecache fast
sudo vi /etc/docker/daemon.json (empty file)
    Add these lines:
    {
          "storage-driver": "devicemapper"
    }

3) Start docker
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run hello-world

4) Download the Docker Machine binary and extract it to your PATH
curl -L https://github.com/docker/machine/releases/download/v0.11.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

5) check version of docker-machine
docker-machine version

6) enable the docker-machine shell prompt:
vi ~/.bashrc
    Add these lines:
    PS1='[\u@\h \W$(__docker_machine_ps1)]\$ '

7) Install bash completion for docker-machine (optional)

Install bash-completion script:
cd Docker/bash-completion
./setup_bash_completion.sh

8) Install virtualbox driver on Centos 7
cd /etc/yum.repos.d/
sudo wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
yum update
reboot (for new kernel to update)
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms
yum install binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-PAE-devel dkms
yum search VirtualBox- ==> yum install <VirtualBox>-<newest-version>
/usr/lib/virtualbox/vboxdrv.sh setup
usermod -a -G vboxusers <your_user_name> (baohuynh, add user to group vboxusers)

9) Create docker-machine
+ docker-manager create --driver Virtualbox manager1 
(if not OK, use workaroud to download the latest boot2docker iso:
curl -L https://github.com/boot2docker/boot2docker/releases/download/v17.05.0-ce/boot2docker.iso > ~/.docker/machine/cache/boot2docker.iso )
+ docker-machine rm manager1 (rm old machine)
+ docker-manager create --driver Virtualbox manager1 (create new one)

10) Install docker-compose
+ curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/sbin/docker-compose
+ chmod +x /usr/local/sbin/docker-compose
