# How to deploy ci/cd DevOps tools
	
- Provisioning with Terraform TODO
- Install git client:

```shell
yum update -y && yum install git -y
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

- Deploying ci-cd tools (Jenkins, GitLab, SonarQube, Portainer) typing:

```shell
docker-compose -f docker-compose.fullcicd.yml up -d
```