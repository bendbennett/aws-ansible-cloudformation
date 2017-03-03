# Ansible - AWS CloudFormation

This repo contains Ansible code and AWS CloudFormation templates for the
provisioning of AWS resources.
 
## Requirements
 
* Install Ansible - [docs](http://docs.ansible.com/ansible/intro_installation.html)
* Set-up Ansible for controlling AWS - [docs](http://docs.ansible.com/ansible/guide_aws.html)
 
## Example 
To provision a VPC with 2 public and 2 private subnets run the following:
 
    cd ansible/
    ansible-playbook vpc.yml
    
To take down the subnets and VPC run 
    
    ansible-playbook vpc-down.yml