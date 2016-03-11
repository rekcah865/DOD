# DOD - Dev Oracle database in Docker with NFS storage

Run about 10 dev Oracle instances with Docker container and locate db file in NFS storage  

And run dev Oracle database in anther container with linking DB container

### Dev DB Environment

* Host 
	- OS:	OEL 6.7
	- Kernel: 3.8.13
	- Docker Version:	1.8.3
	
* DB Container

	- OS: 	Oracle Linux 6.7
	- Oracle Database: Enterprise Edition 11gR2 
	
* App Container

	- OS:	Oracle Linux 6.7
	
* Storage

	- NFS from GlusterFS storage

### Preparation for Docker

* Check OS

```
# yum update
...
# uname -a

# cat /etc/redhat-release

```

* Install Docker

```
# cat >  /etc/yum.repos.d/docker.repo << EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/oraclelinux/6
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# yum install -y docker-engine
...
# chkconfig docker on
# service docker start
# docker version

```

* Create Docker user

```
# useradd -g docker -G root -d /u01/usr/docker docker
# echo "docker  ALL=(ALL)       NOPASSWD:ALL"  >> /etc/sudoers
# echo "docker:docker" |chpasswd 
# su - docker
$ docker pull oraclelinux:6.7
...
$ docker images

```

* NFS storage

```
# mkdir -p /vol
# mount suzglfs:/szbkp-vol/devdb /vol
# mkdir -p /vol/oradata /vol/usr /vol/files
# echo "suzglfs:/szbkp-vol/devdb /vol" /etc/rc.d/rc.local

```

### Build DB Container

```

$ docker build --rm -t devdb .

```

### Build App Container


	


	