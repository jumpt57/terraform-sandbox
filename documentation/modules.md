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
