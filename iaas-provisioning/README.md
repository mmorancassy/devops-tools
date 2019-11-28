# Provisioning Droplets using Terraform + Digital Ocean

- First edit **config.properties** file with your Digital Ocean access token

```shell
# Digital Ocean access token
DO_PATH=794ae291b1e7277988196337a35a8d683748347381e52f7f8a0339d62e3150623
```

- Also, you can set log level

```shell
# Terraform log level, TRACE, DEBUG, INFO, WARN or ERROR
TF_LOG=DEBUG
```

- You can create Digital Ocean Droplet with 'create' argument

```shell
./terraform-provisioning.sh create
```

- Aditionally you can delete Digital Ocean Droplet with 'delete' argument

```shell
./terraform-provisioning.sh delete
```
