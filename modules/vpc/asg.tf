resource "aws_security_group" "public_tcp_3000" {
  description = "Security group allowing traffic on port 3000"
  name        = "weijie-nuxt-sg"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "weijie-nuxt-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_3000" {
  security_group_id = aws_security_group.public_tcp_3000.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0 #temp make it all ports
  ip_protocol       = "tcp"
  to_port           = 65535 #temp make it all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.public_tcp_3000.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

resource "aws_launch_template" "web" {
  default_version                      = 1
  description                          = "nuxt-demo-app"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = null
  image_id                             = "ami-07c9c7aaab42cba5a"
  instance_initiated_shutdown_behavior = null
  instance_type                        = "t2.micro"
  kernel_id                            = null
  key_name                             = null
  name                                 = "weijie-launchTemplate"
  name_prefix                          = null
  ram_disk_id                          = null
  update_default_version               = null
  user_data                            = "IyEvYmluL2Jhc2gKc3VkbyBkbmYgdXBkYXRlIC15CnN1ZG8gZG5mIGluc3RhbGwgLXkgZG9ja2VyCnN1ZG8gc3lzdGVtY3RsIHN0YXJ0IGRvY2tlcgpzdWRvIHN5c3RlbWN0bCBlbmFibGUgZG9ja2VyCnN1ZG8gdXNlcm1vZCAtYUcgZG9ja2VyICRVU0VSCnN1ZG8gZG9ja2VyIC0tdmVyc2lvbgpzdWRvIGRvY2tlciBwdWxsIHBodWF3ZWlqaWUvZGVtby1udXh0CnN1ZG8gZG9ja2VyIHJ1biAtZCAtcCAzMDAwOjMwMDAgcGh1YXdlaWppZS9kZW1vLW51eHQ6bGF0ZXN0"
  vpc_security_group_ids               = []
  block_device_mappings {
    device_name  = "/dev/xvda"
    no_device    = null
    virtual_name = null
    ebs {
      delete_on_termination = jsonencode(true)
      encrypted             = null
      iops                  = 3000
      kms_key_id            = null
      snapshot_id           = "snap-061f3ca570d9ae0a6"
      throughput            = 125
      volume_size           = 8
      volume_type           = "gp3"
    }
  }
  network_interfaces {
    associate_carrier_ip_address = null
    associate_public_ip_address  = jsonencode(true)
    delete_on_termination        = null
    description                  = null
    device_index                 = 0
    interface_type               = null
    ipv4_address_count           = 0
    ipv4_addresses               = []
    ipv4_prefix_count            = 0
    ipv4_prefixes                = []
    ipv6_address_count           = 0
    ipv6_addresses               = []
    ipv6_prefix_count            = 0
    ipv6_prefixes                = []
    network_card_index           = 0
    network_interface_id         = null
    primary_ipv6                 = null
    private_ip_address           = null
    security_groups              = [aws_security_group.public_tcp_3000.id]
    subnet_id                    = null
  }
}

resource "aws_autoscaling_group" "web" {
  name                      = "weijie-auto-scaling-group"
  vpc_zone_identifier       = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 3
  #   service_linked_role_arn   = "arn:aws:iam::479833041972:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  target_group_arns = [aws_lb_target_group.app_front_end.arn]

  launch_template {
    id = aws_launch_template.web.id
  }
}
