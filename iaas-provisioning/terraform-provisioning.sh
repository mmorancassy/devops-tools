#!/bin/bash

source config.properties

export TF_LOG=$TF_LOG

fingerprint=$(ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}')

# VM creation:

if [ "$1" == "create" ]; then
	terraform init 
	
	terraform plan \
	  -var "do_token=$DO_PAT" \
	  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
	  -var "pvt_key=$HOME/.ssh/id_rsa" \
	  -var "ssh_fingerprint=$fingerprint"
	  
	terraform apply \
	  -var "do_token=$DO_PAT" \
	  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
	  -var "pvt_key=$HOME/.ssh/id_rsa" \
	  -var "ssh_fingerprint=$fingerprint" \
	  -auto-approve
fi
  
# VM deletion:
 
if [ "$1" == "delete" ]; then  
	terraform plan -destroy -out=terraform.tfplan \
	  -var "do_token=$DO_PAT" \
	  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
	  -var "pvt_key=$HOME/.ssh/id_rsa" \
	  -var "ssh_fingerprint=$fingerprint"
	  
	terraform apply terraform.tfplan
fi

exit 0  