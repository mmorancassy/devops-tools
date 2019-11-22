### Provisioning Droplets using Terraform + Digital Ocean

# You can do it with this sh:

Invoke script ./terraform-provisioning.sh create --> Creates 3 Droplets in Digital Ocean

Invoke script ./terraform-provisioning.sh delete --> Destroy Droplets in Digital Ocean 

Or yo can do it manually following these steps:

# Init project

terraform init 

# VM creation:

terraform plan \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_fingerprint=MD5:b9:42:af:05:0d:2e:4e:4a:f3:3c:fb:5a:ab:0a:52:0f"
  
terraform apply \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_fingerprint=MD5:b9:42:af:05:0d:2e:4e:4a:f3:3c:fb:5a:ab:0a:52:0f" \
  -auto-approve
  
# VM deletion:
  
terraform plan -destroy -out=terraform.tfplan \
  -var "do_token=${DO_PAT}" \
  -var "pub_key=$HOME/.ssh/id_rsa.pub" \
  -var "pvt_key=$HOME/.ssh/id_rsa" \
  -var "ssh_fingerprint=MD5:b9:42:af:05:0d:2e:4e:4a:f3:3c:fb:5a:ab:0a:52:0f"
  
terraform apply terraform.tfplan  

# To obtain ssh_fingerprint:

ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'
