# dev_platform_administrator
This Repository is used to create development platform for diggibyte
all resource created under the resource group DGB-RG-DL-DEV-001  



to set up workspace locally please follow the steps: 

1. update git submodules
``` 
git submodule  add https://dev.azure.com/diggibyte/diggibyte-platform/_git/platform_tfmodules
```

make sure you have all the required variables in class path to update remote state on azure 
### for mac n linux
```
export TF_VAR_subscription_id="XXXXXX-XX-XXX-XX-XXXXXXXX"
export TF_VAR_tenant_id="XXXXXXX-XXX-XXX-XXXX-XXXXXXXXX"
export TF_VAR_client_id="XXXXXXXX-XXX-XXX-XXX-XXXXXXXX"
export TF_VAR_client_secret="XXXXXXXXXXXXXXXXXXXXXXXX"
export TF_VAR_access_key=XXXXXXXXXbS1V009Bwn7oWWLNsZuXd5wVQiv8rpLTwXXXXXXXXXXXXXXdQ==
```

### for mac n linux
```
set TF_VAR_subscription_id="XXXXXX-XX-XXX-XX-XXXXXXXX"
set TF_VAR_tenant_id="XXXXXXX-XXX-XXX-XXXX-XXXXXXXXX"
set TF_VAR_client_id="XXXXXXXX-XXX-XXX-XXX-XXXXXXXX"
set TF_VAR_client_secret="XXXXXXXXXXXXXXXXXXXXXXXX"
set TF_VAR_access_key=XXXXXXXXXbS1V009Bwn7oWWLNsZuXd5wVQiv8rpLTwXXXXXXXXXXXXXXdQ==
```

```
terraform   -chdir="./datalake/"  init 
terraform -chdir="./datalake/"  plan --var-file dev_terraform.tfvars
```