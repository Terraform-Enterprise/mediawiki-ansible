
provider "aws" {

  region     = var.region
}
resource "tls_private_key" "mw_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.keyname
  public_key = tls_private_key.mw_key.public_key_openssh
}

resource "local_file" "private_key_wiki" {
    depends_on = [aws_key_pair.generated_key]
    content     = tls_private_key.mw_key.private_key_pem
    file_permission      = "0600"
    filename = var.private_key_file_path
}
resource "aws_instance" "bastion" {
  depends_on = [aws_key_pair.generated_key]
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name  = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id     = aws_subnet.mediwiki_Public_subnet2.id
  associate_public_ip_address = true
  tags = {
    Name = lookup(var.aws_tags,"bastion")
    group = "web"
  }
  
}
resource "aws_autoscaling_group" "mediawiki_app_asg" {
  name                      = "mediawiki_app_asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = false
  launch_configuration      = aws_launch_configuration.mediawiki_app_lc.name
  vpc_zone_identifier       = [aws_subnet.mediwiki_Private_subnet2.id]
  load_balancers            = [aws_elb.mw_elb.id]

  tag {
    key                 = "Name"
    value               = "mediawiki_app"
    propagate_at_launch = true
  }
  
  lifecycle {
    ignore_changes = [
      desired_capacity,
      max_size,
      min_size,
    ]
  }
}

resource "aws_launch_configuration" "mediawiki_app_lc" {
  lifecycle {
    create_before_destroy = true
  }
  name_prefix                 = "mediawiki_lc"
  image_id                    = var.aws_ami
  instance_type               = var.aws_instance_type
  user_data                   = data.template_file.mediawiki_app_data.rendered
  key_name                    = aws_key_pair.generated_key.key_name
  ebs_optimized               = true
  associate_public_ip_address = false
  security_groups             = [aws_security_group.app_sg.id]

}


data "template_file" "mediawiki_app_data" {
  template = file("mediawiki_app_data.tpl")
  } 
resource "aws_elb" "mw_elb" {
  name = "MediaWikiELB"
  subnets         = [aws_subnet.mediwiki_Public_subnet1.id,aws_subnet.mediwiki_Public_subnet2.id]
  security_groups = [aws_security_group.lb_sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

}



output "elb_address" {
  value = aws_elb.mw_elb.dns_name
}
output "public_key_pair" {
  value       = aws_key_pair.generated_key.public_key
  description = "Name of the created AWS key pair."
}
output "private_key" {
        value = tls_private_key.mw_key.private_key_pem 
        description = "Name of the created AWS private key pair"
}
output "key_pair_name" {
  value       = aws_key_pair.generated_key.key_name
  description = "Name of the created AWS key pair."
}

