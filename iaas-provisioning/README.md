# Provisioning Droplets using Terraform + Digital Ocean

### First edit **config.properties** file with your Digital Ocean access token

```shell
# Digital Ocean access token
DO_PATH=
``

### You can create Digital Ocean Droplet with 'create' argument

```shell
./terraform-provisioning.sh create --> Creates 1 Droplets in Digital Ocean
```

### Aditionally you can delete Digital Ocean Droplet with 'delete' argument

```shell
./terraform-provisioning.sh delete --> Destroy Droplets in Digital Ocean 
```
