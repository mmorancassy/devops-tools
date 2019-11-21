# How to deploy ci/cd DevOps tools
	
- Provisioning Digital Ocean Droplet with Terraform (CentOS>=7 based) TODO
- Access provisioned virtual machine via ssh
- Copy sh script **centos7-base-software.sh** and give it execution permissions

```shell
chmod 755 centos7-base-software.sh
```

- Copy **config.properties** file to the same directory that previous script is located and edit with the vm ip address

```shell
COMMONNAME=127.0.0.1
IP=127.0.0.1
DNS=127.0.0.1
```

- Execute the script (this script installs base software like git, docker, docker-compose and generates self signed certificates)

```shell
./centos7-base-software.sh
```

- Clone this repository:

```shell
git clone https://github.com/mmorancassy/devops-tools.git
```

- Copy self signed certificates located at **/tmp/tls** folder to **devops-tools/reverseproxy/nginx**

```shell
mv /tmp/tls devops-tools/reverse-proxy/nginx/certs
```

- Deploying ci-cd tools (Jenkins, GitLab, SonarQube, Nexus, Portainer) typing:

```shell
docker-compose -f docker-compose.fullcicd.yml up -d
```

- Finally you can access every tool:

Portainer: [https://<host_ip>/portainer](https://<host_ip>/portainer "https://<host_ip>/portainer")

Jenkins: [https://<host_ip>/jenkins](https://<host_ip>/jenkins "https://<host_ip>/jenkins")

SonarQube: [https://<host_ip>/sonar](https://<host_ip>/sonar "https://<host_ip>/sonar")

Nexus: [https://<host_ip>/nexus](https://<host_ip>/nexus "https://<host_ip>/nexus")

GitLab: [https://<host_ip>](https://<host_ip> "https://<host_ip>")

# Custom configuration

- If you want to store your persistent data in other location you have to edit file **.env** located in folder **devops-tools/cicd-tools** and change every location as your needs, and **config.properties** and edit **DATA_PATH** variable

```shell
# Persistent data
DATA_PATH=/var
```

```shell
# Persistent data
DATA_PATH=/var
```