Terraform - Ansible Mediawiki Installation

Ansible-playbook:

* Playbook for installation and configuration of mediawiki. 

 data.yml : Playbook for installation and configuration of DB

 site.yml : Playbook for installation and configuration of APP
 
 Password to decrypt DB credentials is in  --vault-password-file "vault-pwd.txt" 
 use #ansible-vault view vault.yml (To view DB password )

 Database Name : wikidatabase
 Database User : wiki
 command to view DB password : ansible-vault view vault.yml (password is in vault-pwd.txt)

Infra On AWS Terraform:

A complete end to end infrastructure has been created using Terraform in AWS cloud. This template include Route53,ELB,Autoscaling,Bastion,APP and DB

Prerequisites:

* Have Terraform ~> 0.13.0 installed.

The resource configuration is split in the following modules placed in sub directories.

* Route 53 : A hosted zone and record set will be created

* network - network resources needed for the mediawiki instalation A VPC,private and public subnets,NAT,IGW,Routablw

* Security - This include security group for all the layers (LB,Bastion,APP and DB)

* server - key-pair,Bastion,Launc configutation and Auto scaling group

Note : Move to /mediawiki-ansible/infra-on-aws-terraform directory to run terraform

Input Variables:

my_office_cidrblock   : Provide a valid CIDR for loadbalancer to communicate with Application (kindly change it in variables.tf)

hosted_zone_name:  A valid existing Domain  name for the creating Route 53 hosted zone

mediawiki_domain_name  : Record set name for mapping ELB endpoint in A record

aws_ami           : RHEL 7.5 ami-04642fc8fca1e8e67

aws_instance_type       : Your preferred Instance type

Note : please replace your credentials in terraform.tfvars


Outputs:

The root module exposes the outputs described below

ELB Address  :  Load balance address

Public_key_pair:  The public IP address of the SSH hop 

Private_key:  The private key of the TLS key pair 

Key_pair_name : Name of the public key pair

FQDN : Route53 FQDN


Provisioning with Terraform

set the Terraform module input variables as described here (https://www.terraform.io/docs/language/values/variables.html#assigning-values-to-root-module-variables).

Set AWS credentials according to the Terraform AWS provider documentation (https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

check and confirm the changes terraform will make to the infrastructure

terraform plan

provision the infrastructure

terraform apply
