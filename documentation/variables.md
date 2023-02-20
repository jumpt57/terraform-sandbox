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

