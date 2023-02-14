# terraform-sandbox

## Concepts

- Terraform Core
- Terraform State
- Terraform Config
- Provider
- AWS Provider

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


## State

### Local Backend

- Simple to get started
- Sensitive values in plain text
- Uncollaborative
- Manual

### Remote Backend

1. Terraform Cloud
2. Self-manage (AWS S3, Google Cloud Storage ...)

- Sensitive data encrypted
- Collaboration possible
- Automation possible
- Increased complexity


## Variables

### Variable types

1. Input variables 

```
variable "my_var" {
    decription = ""
    type = string
    default = ""
}

var.<name>
```

2. Local variables
```
locals {
    test = ""
    test_2 = ""
}


local.<name>
```

3. Output variables
```
output "my_variable" {
    value = aws_*.name.arn
}
```

### Setting Input Variables

- Manuel entry during plan / apply
- Default value in declaration block
- TF_VAR_<name> env variables
- terraform.tfvars file
- *.auto.tfvars file
- Command line -var or -var-file

```
$ terraform apply -var-file=
$ terraform apply -var="db_user=dffsdfsdfsd"
```

### Types & Validation

#### Primitives

- string
- number
- bool

#### Complex

- list(<TYPE>)
- set(<TYPE>)
- map(<TYPE>)
- object({<ATTR NAME> = <TYPE>, ...})
- tuple([<TYPE>, ...])

#### Validation

- Type checking happens automatically
- Custom conditions can also be enforced

### Sensitive Data

```
variable "" {
    description = ""
    type = string
    sensitive = true
}
```

- TV_VAR_variable
- -var (retrived from secret manager at runtime)

Can also use external secret store like :
- AWS Secrets Manager

## Expressions + Functions

### Expressions

- Template strings
- Operatos (!, -, *, /, %, >, ==, etc...)
- Conditionals (cond ? true : false)
- For ([for o in var.list : o.id])
- Splat (var.list[*].id)
- Dynamic Blocks
- Constraints (Type & Version)

### Functions

- Numeric
- String
- Collection
- Encoding
- Filesystem
- Date & Time
- Hash & Crypto
- Type Conversion

## Meta-arguments

### depends_on

- Will enforce ordering

```

resource "aws_iam_role_policy" "example" {
    role = aws_iam_role.example.name
}

resource "aws_iam_role_policy" "example" {
    name = "example"
    role = aws_iam_role.*
    policy = jsonencode({
        "Statement" = [{
            "Action" = "s3:*"
            "Effect" = "Allow"
        }]
    })
}

resource "aws_instance" "example" {
    ami = ""
    instance_type = ""
    iam_instance_profile = aws_iam_instance_profile.*
    
    depends_on = [
        aws_iam_role_policy.example, <---- Would fail if aws_iam_role_policy does not exist yet
    ]
}

```

### count

- Allows for createing of multiple resource / Module from single block
- Great if you need multiple resources that are the same

```

resource "awa_instance" "server" {

    count = 4 # create four EC2 instances

    ami = ""
    instance_type = ""
    
    tags = {
        Name = "Server ${count.index}"
    }
    
    
}

```

### for_each

- Allows for creation of multiple resource / module from single block
- Allows more control to customize each resource (unlike count)

```

locals {
    subnet_ids = toset([
        "subnet-abcde",
        "subnet-0987"
    ])
}

resource "aws_instance" "server" { 

    for_each = local.subnet_ids

    ami = ""
    instance_type = ""
    subnet_id = each.key
    
    tags = {
        Name = "Server ${each.key}"
    }

}


```

### lifecycle

- To control terraform behavior for specific resources
- create_before_destroy can help with zero downtime deployments
- ignore_changes prevents terraform from trying to revert metadata being set elsewhere
- prevent_destroy causes terraform to reject any plan which would destroy this resource

```
resource "aws_instance" "server" { 



    ami = ""
    instance_type = ""
    
    
    lifecycle {
        create_before_destroy = true
        ignore_changes = [
            tags
        ]
        
    }

}


```


## Provisioners

Perform action on local or remote machine

- file
- local-exec
- remote-exec
- vendor
    - chef
    - puppet

## Modules

- Possible to abstract some behavior to be reused somewhere else
- Can be created by infra specialist to be used by app devs
- 

### Types

- Root Module: Default module containing all .tf files in main working directory
- Child Module : A separate external module referred to form a .tf file

Modules sources :
- local paths
- terraform registry
- github
- bitbucket
- Generic git repo
- Http Urls
- S3 buckets
- GCS buckets


1. Local Paths

```
module "web-app" {
    source = "../web_app"
}
```

2. Terraform Registry

```
module "consul" {
    source = "hashicorp/consul/aws"
    version = "0.1.0"
}
```

3. Github

HTTS
```
module "example" {
    source = "github.com/hashicorp/example?ref=v1.2.0"
}
```

SSH
```
module "example" {
    source = "git@github.com/hashicorp/example.git"
}
```

Generic
```
module "example" {
    source = "git::ssh//username@example.com/storage.git"
}
```

### Inputs + Meta-arguments

```
module "example" {
    source = ""
    
    # Input variables
    bucket_name = ""
    domain = ""
}
```

How to build a good module ?

- Raises the abstraction level from base resource types
- Groups resource in a logical fashion
- Exposes input variables to allow necessary cutomization + composition
- Provide useful defaults
- Returns outputs to make further integrations possible

## Environments

### Workspaces

Multiple named sections within a single backend

1. Pros
- Easy to get started
- Convenient terraform.workspace expression
- Minimizes Code Duplication

2. Cons
- Prone to human error
- State stored within same backend codebase doesn't unambiguously show deployment configurations

#### Commands

```
$ terraform workspace list
$ terraform workspace new production
```


### File Structure

- Directory layout provides separation, modules provide reuse

1. Pros
- Isolation of backends
    - Improved security
    - Decreased potential for human error
- Codebase fully represents deployed state

2. Cons 
- Multiple terraform apply required to provision environments
- More code duplicationm but can be minimized with modules


Also :
- Further separation (at logical component groups) useful for larger projects
    - Isolate things that conge frequently from those which don't
- Referencing resources across configurations is possible using terraform_remote_state

### Terragrunt

Tool by gruntwork.io that provides utilities to make certain Terraform use cases easier

- Keeping Terraform code DRY
- Executing commands across multiple TF configs
- Working with multiple cloud accounts