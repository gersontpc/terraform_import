
# Importando recurso já criado no Terraform

## Importando recurso
Para realizar o import siga os passos abaixo:


1. Crie um recurso vazio, no exemplo a seguir será criado um `aws_alb`.

```terraform
resource "aws_lb" "nlb" {}
```

2. Agora crie o recurso para realizar o import, utilize o comando `terraform import <recurso-tf>.<nome-recurso> "arn-do-recurso"`, exemplo abaixo:

```bash
$ terraform import aws_lb.nlb "arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698"
```

Output:
```bash
aws_lb.nlb: Importing from ID "arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698"...
aws_lb.nlb: Import prepared!
  Prepared aws_lb for import
aws_lb.nlb: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

3. Após ter realizado o import, adicione os parâmetros de configurações de acordo com o que foi criado através do console.

```terraform
resource "aws_lb" "nlb" {
  name               = "nlb-backend"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets_id
}

variable "subnets_id" {
    type = list
    description = "Set subnets_id"
    default = ["subnet-0aaaaaa0", "subnet-1aaaaaa1" ,"subnet-2aaaaaa2"]
}
```

4. Realize o `terraform plan` para ver se está sincronizado o terraform com o recurso criado na aws pelo console.


```terraform
$ terraform plan
```
Output:
```terraform
aws_lb.nlb: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```

5. Adicione o bloco `tags` para poder aplicar no recurso que agora está sendo gerenciado pelo Terraform.

Alterando os blocos:
```terraform
resource "aws_lb" "nlb" {
  name               = "nlb-backend"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets_id

  tags = {
    Environment = "developer"
  }
}

variable "subnets_id" {
    type = list
    description = "Set subnets_id"
    default = ["subnet-0aaaaaa0", "subnet-1aaaaaa1" ,"subnet-2aaaaaa2"]
}
```

6. Realize `terraform plan` para aplicar a tag: `Environment = developer`.


```terraform
$ terraform plan
```
Output:
```terraform
aws_lb.nlb: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_lb.nlb will be updated in-place
  ~ resource "aws_lb" "nlb" {
        id                               = "arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698"
        name                             = "nlb-backend"
      ~ tags                             = {
          + "Environment" = "developer"
        }
      ~ tags_all                         = {
          + "Environment" = "developer"
        }
        # (12 unchanged attributes hidden)

        # (4 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

7. Realize o `terraform apply --auto-approve` para aplicar a alteração da tag.

```terraform
terraform apply --auto-approve
```
Output:

```terraform
aws_lb.nlb: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_lb.nlb will be updated in-place
  ~ resource "aws_lb" "nlb" {
        id                               = "arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698"
        name                             = "nlb-backend"
      ~ tags                             = {
          + "Environment" = "developer"
        }
      ~ tags_all                         = {
          + "Environment" = "developer"
        }
        # (12 unchanged attributes hidden)

        # (4 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
aws_lb.nlb: Modifying... [id=arn:aws:elasticloadbalancing:us-east-1:...:loadbalancer/net/nlb-backend/75d1440f28db9698]
aws_lb.nlb: Still modifying... [id=arn:aws:elasticloadbalancing:us-east-1:...lancer/net/nlb-backend/75d1440f28db9698, 10s elapsed]
aws_lb.nlb: Still modifying... [id=arn:aws:elasticloadbalancing:us-east-1:...lancer/net/nlb-backend/75d1440f28db9698, 20s elapsed]
aws_lb.nlb: Still modifying... [id=arn:aws:elasticloadbalancing:us-east-1:...lancer/net/nlb-backend/75d1440f28db9698, 30s elapsed]
aws_lb.nlb: Modifications complete after 33s [id=arn:aws:elasticloadbalancing:us-east-1:...:loadbalancer/net/nlb-backend/75d1440f28db9698]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

## Limpamdo o ambiente

8. Agora realize o destroy.

```terraform
terraform destroy --auto-approve
```
Output:

```terraform
aws_lb.nlb: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_lb.nlb will be destroyed
  - resource "aws_lb" "nlb" {
      - arn                              = "arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698" -> null
      - arn_suffix                       = "net/nlb-backend/75d1440f28db9698" -> null
      - dns_name                         = "nlb-backend-75d1440f28db9698.elb.us-east-1.amazonaws.com" -> null
      - enable_cross_zone_load_balancing = false -> null
      - enable_deletion_protection       = false -> null
      - id                               = "arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698" -> null
      - internal                         = false -> null
      - ip_address_type                  = "ipv4" -> null
      - load_balancer_type               = "network" -> null
      - name                             = "nlb-backend" -> null
      - security_groups                  = [] -> null
      - subnets                          = [
          - "subnet-0aaaaaa0",
          - "subnet-1aaaaaa1",
          - "subnet-2aaaaaa2",
        ] -> null
      - tags                             = {
          - "Environment" = "developer"
        } -> null
      - tags_all                         = {
          - "Environment" = "developer"
        } -> null
      - vpc_id                           = "vpc-1d6bd267" -> null
      - zone_id                          = "Z26RNL4JYFTOTI" -> null

      - access_logs {
          - enabled = false -> null
        }

      - subnet_mapping {
          - subnet_id = "subnet-0aaaaaa0" -> null
        }
      - subnet_mapping {
          - subnet_id = "subnet-1aaaaaa1" -> null
        }
      - subnet_mapping {
          - subnet_id = "subnet-2aaaaaa2" -> null
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.
aws_lb.nlb: Destroying... [id=arn:aws:elasticloadbalancing:us-east-1:223111117520:loadbalancer/net/nlb-backend/75d1440f28db9698]
aws_lb.nlb: Still destroying... [id=arn:aws:elasticloadbalancing:us-east-1:...lancer/net/nlb-backend/75d1440f28db9698, 10s elapsed]
aws_lb.nlb: Still destroying... [id=arn:aws:elasticloadbalancing:us-east-1:...lancer/net/nlb-backend/75d1440f28db9698, 20s elapsed]
aws_lb.nlb: Still destroying... [id=arn:aws:elasticloadbalancing:us-east-1:...lancer/net/nlb-backend/75d1440f28db9698, 30s elapsed]
aws_lb.nlb: Still destroying... [id=arn:aws:elasticloadbalancing:us-east-1:...lancer/net/nlb-backend/75d1440f28db9698, 40s elapsed]
aws_lb.nlb: Destruction complete after 40s

Destroy complete! Resources: 1 destroyed.
```