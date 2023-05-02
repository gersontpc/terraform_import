resource "aws_lb" "nlb" {
  name               = "nlb-backend"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets_id

  tags = {
    Environment = "developer"
  }
}
