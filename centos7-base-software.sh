#!/bin/bash

#
# Copyright Indra Sistemas, S.A.
# 2013-2018 SPAIN
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#      http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ------------------------------------------------------------------------

source config.properties

# Defining standard output colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

##########################################################
### Git
sudo yum install -y git

if [ $? -eq 0 ]; then
	echo "[GIT]${green}Git installed...................... [OK]${reset}" 
else
	echo "[GIT]${red}Git installed...................... [KO]${reset}"
fi	
	
##########################################################
### Docker engine CE

echo "[Docker - Step 1]${green}############################ Installing Device mapper...${reset}"

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  
if [ $? -eq 0 ]; then
	echo "[$(date)]${green}Device mapper installed...................... [OK]${reset}" 
else
	echo "[$(date)]${red}Device mapper installed...................... [KO]${reset}"
fi	  
    
echo "[Docker - Step 2]${green}############################ Adding Docker repository...${reset}"
  
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo  
    
if [ $? -eq 0 ]; then
	echo "[$(date)]${green}Docker repository succesfully added...................... [OK]${reset}" 
else
	echo "[$(date)]${red}Docker repository succesfully added...................... [KO]${reset}"
fi	    

echo "[Docker - Step 3]${green}############################ Installing Docker CE...${reset}"
  
sudo yum install -y docker-ce docker-ce-cli containerd.io 

if [ $? -eq 0 ]; then
	echo "[$(date)]${green}Docker CE installed...................... [OK]${reset}" 
else
	echo "[$(date)]${red}Docker CE installed...................... [KO]${reset}"
fi

echo "[Docker - Step 4]${green}############################ Starting Docker service...${reset}"

sudo systemctl start docker

if [ $? -eq 0 ]; then
	echo "[$(date)]${green}Docker CE engine installed...................... [OK]${reset}" 
else
	echo "[$(date)]${red}Docker CE engine installed...................... [KO]${reset}"
fi	  
  

##########################################################
### Docker compose	

echo "[Docker Compose - Step 1]${green}############################ Downloading Docker Compose binary file...${reset}"

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo "[Docker Compose - Step 2]${green}############################ Giving permissions...${reset}"

sudo chmod +x /usr/local/bin/docker-compose

if [ $? -eq 0 ]; then
	echo "[$(date)]${green}Docker Compose installed...................... [OK]${reset}" 
else
	echo "[$(date)]${red}Docker Compose installed...................... [KO]${reset}"
fi

##########################################################
### Create folders

echo "[Creating folders - Step 1]${green}############################ Creating ci-cd persistent directories...${reset}"

mkdir -p /var/devtools/data/jenkinsdata
mkdir -p /var/devtools/data/platform_config
mkdir -p /var/devtools/data/gitlabdata/config
mkdir -p /var/devtools/data/gitlabdata/logs
mkdir -p /var/devtools/data/gitlabdata/data
mkdir -p /var/devtools/data/gitlabdata/certs
mkdir -p /var/devtools/data/nexusdata
mkdir -p /var/devtools/data/sonar/sqconf
mkdir -p /var/devtools/data/sonar/sqdata
mkdir -p /var/devtools/data/sonar/sqext
mkdir -p /var/devtools/data/sonar/sqplugins
mkdir -p /var/devtools/data/sonar/postgresql
mkdir -p /var/devtools/data/sonar/postgresql/data 
mkdir -p /var/devtools/data/portainer

chown -R 200 /var/devtools/data/nexusdata

##########################################################
### Generate self signed certs

echo "[Creating self signed certificates - Step 1]${green}############################ Creating self signed certificates...${reset}"

# Define where to store the generated certs and metadata.
DIR="$(pwd)/tls"

# Optional: Ensure the target directory exists and is empty.
rm -rf "${DIR}"
mkdir -p "${DIR}"

# Create the openssl configuration file. This is used for both generating
# the certificate as well as for specifying the extensions. It aims in favor
# of automation, so the DN is encoding and not prompted.
cat > "${DIR}/openssl.cnf" << EOF
[req]
default_bits = 2048
encrypt_key  = no # Change to encrypt the private key using des3 or similar
default_md   = sha256
prompt       = no
utf8         = yes

# Speify the DN here so we aren't prompted (along with prompt = no above).
distinguished_name = req_distinguished_name

# Extensions for SAN IP and SAN DNS
req_extensions = v3_req

# Be sure to update the subject to match your organization.
[req_distinguished_name]
C  = ES
ST = MyCompany
L  = Madrid
O  = MyOrganization
CN = $COMMONNAME

# Allow client and server auth. You may want to only allow server auth.
# Link to SAN names.
[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = keyCertSign, cRLSign
extendedKeyUsage     = clientAuth, serverAuth
subjectAltName       = @alt_names

# Alternative names are specified as IP.# and DNS.# for IP addresses and
# DNS accordingly. 
[alt_names]
IP.1  = $IP 
DNS.1 = $DNS
EOF

# Create the certificate authority (CA). This will be a self-signed CA, and this
# command generates both the private key and the certificate. You may want to 
# adjust the number of bits (4096 is a bit more secure, but not supported in all
# places at the time of this publication). 
#
# To put a password on the key, remove the -nodes option.
#
# Be sure to update the subject to match your organization.
openssl req \
  -new \
  -newkey rsa:2048 \
  -days 120 \
  -nodes \
  -x509 \
  -subj "/C=ES/ST=MyCompany/L=Madrid/O=MyOrganization" \
  -keyout "${DIR}/cacert.key" \
  -out "${DIR}/cacert.crt"
#
# For each server/service you want to secure with your CA, repeat the
# following steps:
#

# Generate the private key for the service. Again, you may want to increase
# the bits to 4096.
openssl genrsa -out "${DIR}/selfsigned.key" 2048

# Generate a CSR using the configuration and the key just generated. We will
# give this CSR to our CA to sign.
openssl req \
  -new -key "${DIR}/selfsigned.key" \
  -out "${DIR}/selfsigned.csr" \
  -config "${DIR}/openssl.cnf"
  
# Sign the CSR with our CA. This will generate a new certificate that is signed
# by our CA.
openssl x509 \
  -req \
  -days 120 \
  -in "${DIR}/selfsigned.csr" \
  -CA "${DIR}/cacert.crt" \
  -CAkey "${DIR}/cacert.key" \
  -CAcreateserial \
  -extensions v3_req \
  -extfile "${DIR}/openssl.cnf" \
  -out "${DIR}/selfsigned.crt"

# (Optional) Verify the certificate.
openssl x509 -in "${DIR}/selfsigned.crt" -noout -text

echo "[Creating self signed certificates - Step 2]${green}############################ Copying self signed certificates...${reset}"

mv tls /tmp/tls
 
exit 0