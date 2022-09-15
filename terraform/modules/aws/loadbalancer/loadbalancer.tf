
## alb area 
# ALB

resource "aws_lb" "web-alb" {
    name = var.lb_name
    internal           = var.lb_internal
    load_balancer_type = var.lb_type
    security_groups    = var.security_groups
    subnets            = var.subnets
    tags               = var.tag_name
}

# Target Group
resource "aws_lb_target_group" "web-alb-tg" {
    name     = var.lb_target_group_name
    port     = var.port
    protocol = var.lb_protocol
    vpc_id   = var.vpc_id
    tags     = var.tg_tag_name
}


resource "aws_lb_listener" "web-alb-listen" {
    load_balancer_arn =  aws_lb.web-alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn =  aws_lb_target_group.web-alb-tg.arn
    }
}





#resource "aws_alb_target_group_attachment" "tgr_attachment" {
#  for_each = {
#    for pair in setproduct(keys(aws_lb_target_group.web-alb-tg), var.nlb_listeners_ids) : "${pair[0]}:${pair[1]}" => {
#      target_group = aws_lb_target_group.web-alb-tg[pair[0]]
#      instance_id  = pair[1]
#    }
#  }
#  target_group_arn = each.value.target_group.arn
#  target_id        = each.value.instance_id
#  #port             = each.value.target_group.port
#  port = var.target_port
#}


