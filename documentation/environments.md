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