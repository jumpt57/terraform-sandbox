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


List of state of resources during their lifecyles :
- create : exists in the conf but not in the infra
- destroy : resource that exists in the infra but not in the cong
- update in-place : resource who's args have changed
- destroy then create replacement : resource whose args have changed but cannot be updaated because of limitation

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

Availables arguments 
- `create_before_destroy` : (bool) can help with zero downtime deployments, it will create the new resource before deleting the new one
- `ignore_changes` : (list of attributes) prevents terraform from trying to change the resource because of one of the listed attribute
- `prevent_destroy` : (bool) causes terraform to reject any plan which would destroy this resource
