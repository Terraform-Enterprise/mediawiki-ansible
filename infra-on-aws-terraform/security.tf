resource "aws_security_group" "lb_sg" {
  name        = "mediawiki-LB-sg"
  description = "Allow needed needed traffic for APP Instance."
  vpc_id      = aws_vpc.mediwiki_vpc.id
}
resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks  = var.my_office_cidrblock
  security_group_id = aws_security_group.lb_sg.id
}
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks  = var.my_office_cidrblock
  security_group_id = aws_security_group.lb_sg.id
}
resource "aws_security_group_rule" "allow_all_lbout" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks  = ["0.0.0.0/0"]
 security_group_id = aws_security_group.lb_sg.id
 }
resource "aws_security_group" "bastion_sg" {
  name        = "mediawiki-bastion-sg"
  description = "Allow needed needed traffic for APP Instance."
  vpc_id      = aws_vpc.mediwiki_vpc.id
}
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks  = var.my_office_cidrblock
 security_group_id = aws_security_group.bastion_sg.id
 }
 resource "aws_security_group_rule" "allow_all_bas" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks  = ["0.0.0.0/0"]
 security_group_id = aws_security_group.bastion_sg.id
 }
resource "aws_security_group" "app_sg" {
  name        = "mediawiki-App-sg"
  description = "Allow needed needed traffic for APP Instance."
  vpc_id      = aws_vpc.mediwiki_vpc.id
}
resource "aws_security_group_rule" "allow_ssh_lb" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks  = var.my_office_cidrblock
  security_group_id = aws_security_group.app_sg.id
}
resource "aws_security_group_rule" "allow_all_ap" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}
resource "aws_security_group_rule" "allow_all_lb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  source_security_group_id  = aws_security_group.lb_sg.id
  security_group_id = aws_security_group.app_sg.id
}
resource "aws_security_group_rule" "allow_all_bastion" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  source_security_group_id  = aws_security_group.bastion_sg.id
  security_group_id = aws_security_group.app_sg.id
}