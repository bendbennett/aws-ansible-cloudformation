# Ansible - AWS CloudFormation

This repo contains Ansible code and AWS CloudFormation templates for the
provisioning of AWS resources.
 
## Requirements
 
* Install Ansible - [docs](http://docs.ansible.com/ansible/intro_installation.html)
* Set-up Ansible for controlling AWS - [docs](http://docs.ansible.com/ansible/guide_aws.html)
 
## Example 
To provision:
 
    cd cloud-formation
    ansible-playbook api.yml
    
To take down: 
    
    ansible-playbook api-down.yml