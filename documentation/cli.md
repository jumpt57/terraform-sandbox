## Useful commands

```
$ terraform init

$ terraform plan

$ terrform apply

$ terraform detroy

$ terraforn validate

$ terraform fmt
```

### Terraform init

- Downloads terraform provider from terraform registry
- Put it in working directory (coming from the official registry)
- New .terraform folder in which we see the providers
- Create a lockfile about the specific dependencies and the providers install in that workspace
- If some modules are used (to bundle up code) it will put it in the modules
- Lastly it will create a JSON state file defining all the information about the resources created (it will create sensitive info like password)
  - It can be stored locally or remotely like an S3 bucket

### Terraform plan

- Take terraform config (desired state) and compare it with the terraform state (Actual state)
- Example we have 1 network + 3 VMs + 1 db and we want to plan 1 network + 4 VMs + 1 db
- Plan will be : +1 vm
- It will prepare the steps needed with the API to do it

### Terraform apply

- Will tell the AWS Provider to apply the plan and create the new resources
- The desired state will match the actual state

### Terraform destroy

- Will destroy everything in the config link to the project 
- Never run for a live project !

### Terraform validate

- WIll validate the terraform scripts