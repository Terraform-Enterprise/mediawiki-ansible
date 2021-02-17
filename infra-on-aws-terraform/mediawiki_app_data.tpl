#!/bin/bash
sudo yum  install  https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
sudo yum install ansible -y
sudo yum install git -y
git clone --single-branch --branch mediawiki https://github.com/freshdesk/mediawiki-ansible.git
ansible-playbook /mediawiki-ansible/ansible-playbook/site.yml
ansible-playbook /mediawiki-ansible/ansible-playbook/data.yml --vault-password-file /mediawiki-ansible/ansible-playbook/vault-pwd.txt
