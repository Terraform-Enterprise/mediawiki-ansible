
variable "region" {
  type = string
  default =  "us-west-1"
}

variable "azs" {
  type = list
  default = ["us-west-1a", "us-west-1b"]
}

variable "keyname" {
  default = "media"
}
variable "my_office_cidrblock" {
  type = list
  default = ["x.x.x.x/32"]
  description = "Provide your machine IP for loadbalancer to communicate with Application"
}

variable "hosted_zone_name"{
   type  = string
   description = "Provide a valid existing hosted zone name"
  }

variable "mediawiki_domain_name"{
   type  = string
   description = "Provide a valid record set name"
  }

variable "private_key_file_path" {
  type        = string
  description = "The location of the key-pair pem file to be saved"
}
# RHEL 7.5 ami-04642fc8fca1e8e67
variable "aws_ami" {
  type        = string
  description = "provide ami id of RHEL 7.6"
}
variable "aws_tags" {
  type = map
  default = {
    "webserver1" = "MediaWiki-Web-1"
   "bastion" = "MediaWiki-Bastion"
    "dbserver" = "MediaWikiDB" 
  }
}

variable "aws_instance_type" {
  type        = string
  description = "provide your preferred instance type"
}
