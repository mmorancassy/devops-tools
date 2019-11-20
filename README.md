# How to deploy ci/cd DevOps tools
	
- Provisioning Digital Ocean Droplet with Terraform (CentOS>=7 based) TODO
- Access provisioned virtual machine via ssh
- Copy sh script **centos7-base-software.sh** and give it execution permissions

```shell
chmod 755 centos7-base-software.sh
```

- Copy **config.properties** file to the same directory that script is located and edit with the vm ip address

```shell
COMMONNAME=127.0.0.1
IP=127.0.0.1
DNS=127.0.0.1
```

- Execute the script (this script install git, docker, docker-compose and generates self signed certificates)

```shell
./centos7-base-software.sh
```

- Clone this repository:

```shell
git clone https://github.com/mmorancassy/devops-tools.git
```

- Configure scripts/config.properties to generate self signed certificates
- Installing base software, executing:

```shell
./centos7-base-software.sh
```

- Deploying ci-cd tools (Jenkins, GitLab, SonarQube, Nexus, Portainer) typing:

```shell
docker-compose -f docker-compose.fullcicd.yml up -d
```

- Finally you can access every tool:

[https://<host_ip>/portainer](https://<host_ip>/portainer "https://<host_ip>/portainer")

[https://<host_ip>/jenkins](https://<host_ip>/jenkins "https://<host_ip>/jenkins")

[https://<host_ip>/sonar](https://<host_ip>/sonar "https://<host_ip>/sonar")

[https://<host_ip>/nexus](https://<host_ip>/nexus "https://<host_ip>/nexus")

[https://<host_ip>](https://<host_ip> "https://<host_ip>")