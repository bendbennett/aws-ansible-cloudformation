# Ansible - AWS CloudFormation

This repo contains Ansible code and AWS CloudFormation templates for the
provisioning of AWS resources.

A [Symfony 3 API](https://github.com/bendbennett/symfony-api-swagger-jwt) is used to 
illustrate how a web application which can be run within a [Docker-based](https://github.com/bendbennett/docker-compose-nginx-php7-mongo3) 
local development environment can be set-up to run on AWS. 
 
## Requirements

* Install [Ansible](http://docs.ansible.com/ansible/intro_installation.html).
* Set-up Ansible for [authenticating with AWS](hhttp://docs.ansible.com/ansible/guide_aws.html#authentication).

## Set-up

    git clone git@github.com:bendbennett/ansible-aws.git
    cd ansible-aws/cloud-formation
    ansible-playbook basic-network.yml
    ansible-playbook site.yml 

## Tear-down

    cd ansible-aws/cloud-formation
    ansible-playbook site-down.yml
    ansible-playbook basic-network-down.yml
     
## Basic Network  

Running _ansible-playbook basic-network.yml_ runs each of the roles specified in the 
[basic-network](../basic-network.yml) playbook using the variables defined in 
[group_vars/basic-network/main.yml](../group_vars/basic-network/main.yml) and will 
provision:    

* VPC ([AWS::EC2::VPC](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc.html))
  * Internet Gateway ([AWS::EC2::InternetGateway](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-internet-gateway.html))
  * Internet Gateway Attachment ([AWS::EC2::VPCGatewayAttachment](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc-gateway-attachment.html))
* Network ACL ([AWS::EC2::NetworkAcl](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-network-acl.html))
  * Network ACL Entry ([AWS::EC2::NetworkAclEntry](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-network-acl-entry.html))    
* Route Table - public ([AWS::EC2::RouteTable](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route-table.html))
  * Route ([AWS::EC2::Route](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route.html))
* Subnet - public ([AWS::EC2::Subnet](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html))
  * Subnet Network ACL Association ([AWS::EC2::SubnetNetworkAclAssociation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-network-acl-assoc.html))
  * Subnet Route Table Association ([AWS::EC2::SubnetRouteTableAssociation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-route-table-assoc.html))  
* Route Table - private ([AWS::EC2::RouteTable](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route-table.html))
  * Elastic IP ([AWS::EC2::EIP](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-eip.html))
  * NAT Gateway ([AWS::EC2::NatGateway](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-natgateway.html))
  * Route ([AWS::EC2::Route](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-route.html))
* Subnet - private ([AWS::EC2::Subnet](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html))
  * Subnet Network ACL Association ([AWS::EC2::SubnetNetworkAclAssociation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-network-acl-assoc.html))
  * Subnet Route Table Association ([AWS::EC2::SubnetRouteTableAssociation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet-route-table-assoc.html))  
* Hosted Zone - private ([AWS::Route53::HostedZone](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-route53-hostedzone.html))  

### VPC
  
* Creates a Virtual Private Cloud (VPC) / virtual network with the CIDR block specified.
* Creates an Internet Gateway and attaches it to the VPC using an Internet Gateway 
Attachment to allow communication with the internet.

### Network ACL

* Creates a Network Access Control List (ACL) and Network ACL Entries for ingress and egress
as an optional security layer for controlling traffic into and out of subnets.

### Route Table - public

* Creates a Route Table and Route linked to the Internet Gateway.

### Subnet - public

* Creates 3 public Subnet(s) using the specified CIDR blocks, Network ACL and Route Table
(public), placing 1 in each of 3 availability zones.
 
### Route Table - private
 
* Creates 3 Route Table(s), 3 Elastic IP(s) and 3 NAT Gateway(s)  
    
### Subnet - private

* Creates 3 private Subnet(s) using the specified CIDR blocks, Network ACL and Route Table
(private) placing 1 in each of 3 availability zones.
  
### Hosted Zone - private

* Creates a private Hosted Zone for holding record sets.

## Site  

Running _ansible-playbook site.yml_ runs each of the roles specified in the 
[site](../site.yml) playbook using the variables defined in 
[group_vars/site/main.yml](../group_vars/site/main.yml) and will 
provision:    

* Security Group - load balancer ([AWS::EC2::SecurityGroup](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html))
  * Security Group Ingress ([AWS::EC2::SecurityGroupIngress](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group-ingress.html))
  