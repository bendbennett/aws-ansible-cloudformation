# Ansible - AWS CloudFormation

This repo contains Ansible code and AWS CloudFormation templates for the
provisioning of AWS resources.

A [Symfony 3 API](https://github.com/bendbennett/symfony-api-swagger-jwt) is used to 
illustrate how a web application which can be run within a [Docker-based](https://github.com/bendbennett/docker-compose-nginx-php7-mongo3) 
local development environment can be set-up to run on AWS. 
 
## Requirements

* Install [Ansible](http://docs.ansible.com/ansible/intro_installation.html).
* Set-up Ansible for [authenticating with AWS](http://docs.ansible.com/ansible/guide_aws.html#authentication).

### S3

* [Create an S3 bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html)
 called _synaptology-templates_ and upload 
[scripts/upsert-resource-record-set.sh](../master/scripts/upsert-resource-record-set.sh)
to this bucket.

### Register domain name

* Register a domain name using [AWS Route 53](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html).
* Create a [public hosted zone](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/AboutHZWorkingWith.html)
for the domain.
* Uncomment _hosted_zone_public_name_ in [group_vars/site/main.yml](../master/group_vars/site/main.yml) 
and insert the public hosted zone domain name.

### HTTPS

* [Create a certificate](https://aws.amazon.com/certificate-manager/) for *._hosted_zone_public_name_
  (i.e., name inserted for _hosted_zone_public_name_ in the previous step).
* Uncomment _ssl_certificate_id_ in [group_vars/site/main.yml](../master/group_vars/site/main.yml) 
  and insert the certificate ARN.

### Key name

* Uncomment _key_name_ in [group_vars/site/main.yml](../master/group_vars/site/main.yml) 
  and insert the name of the EC2 key pair that you want to use to connect to the EC2 instances.

## Provision network and site

    git clone git@github.com:bendbennett/ansible-aws.git
    cd ansible-aws/cloud-formation
    ansible-playbook basic-network.yml
    ansible-playbook site.yml 

## Remove network and site

    cd ansible-aws/cloud-formation
    ansible-playbook site-down.yml
    ansible-playbook basic-network-down.yml
     
## Basic Network  

Running _ansible-playbook basic-network.yml_ runs each of the roles specified in the 
[basic-network](../master/basic-network.yml) playbook using the variables defined in 
[group_vars/basic-network/main.yml](../master/group_vars/basic-network/main.yml) and will 
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
* Load Balancer ([AWS::ElasticLoadBalancing::LoadBalancer](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-elb.html))
* Security Group - web (nginx / php-fpm) EC2 instance ([AWS::EC2::SecurityGroup](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html))
  * Security Group Ingress ([AWS::EC2::SecurityGroupIngress](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group-ingress.html))
* Security Group - mongo EC2 instance ([AWS::EC2::SecurityGroup](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html))
  * Security Group Ingress ([AWS::EC2::SecurityGroupIngress](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group-ingress.html))
* IAM Role - launch configuration ([AWS::IAM::Role](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html))
* IAM Instance Profile - launch configuration ([AWS::IAM::InstanceProfile](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-instanceprofile.html))
* IAM Role - ecs service ([AWS::IAM::Role](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html))
* Log Group ([AWS::Logs::LogGroup](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html))
* ECS Cluster - mongo ([AWS::ECS::Cluster](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html))
* Launch Configuration + Auto Scaling Group - mongo 
  * [AWS::AutoScaling::LaunchConfiguration](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-launchconfig.html)
  * [AWS::AutoScaling::AutoScalingGroup](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html)
* Task Definition + Service - mongo
  * [AWS::ECS::TaskDefinition](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html)
  * [AWS::ECS::Service](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html)  
* ECS Cluster - web (nginx / php-fpm) ([AWS::ECS::Cluster](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html))
* Launch Configuration + Auto Scaling Group - web (nginx / php-fpm) 
  * [AWS::AutoScaling::LaunchConfiguration](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-launchconfig.html)
  * [AWS::AutoScaling::AutoScalingGroup](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html)
* Task Definition + Service - web (nginx / php-fpm)
  * [AWS::ECS::TaskDefinition](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html)
  * [AWS::ECS::Service](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-service.html)  
* Record Set ([AWS::Route53::RecordSet](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordset.html))  

### Security Group - load balancer
  
* Creates a Security Group for use with the Load Balancer.

### Load Balancer

* Creates a Load Balancer for HTTP requests directed at the API.

### Security Group - web (nginx / php-fpm)
  
* Creates a Security Group for use with EC2 instances that will be running nginx and php-fpm
  containers.

### Security Group - mongo
  
* Creates a Security Group for use with EC2 instances that will be running mongo containers.
  
### IAM Role - Launch Configuration
  
* Creates an IAM Role for use with Launch Configurations used in the set-up of EC2 instances
  that host containers (web + mongo).
  
### IAM Instance Profile   

* Creates an IAM Instance Profile for associating IAM Role with a Launch Configuration.

### IAM Role

* Creates an IAM Role to provide privileges to an ECS Service associated with the Load 
  Balancer.
  
### Log Group
  
* Creates a Log Group for use by containers defined in Task Definitions.
 
### ECS Cluster - mongo

* Creates an ECS Cluster for associating with ECS Service for EC2 instances running MongoDB 
  containers.
  
### Launch Configuration + Auto Scaling Group - mongo
  
* Creates Launch Configuration to define EC2 instances used for hosting MongoDB containers
  and an Auto Scaling Group to define instance number.
  
### Task Definition + Service - mongo
  
* Creates an ECS Task Definition which defines the container and configuration that 
  will be deployed and an ECS Service which defines the desired number of containers
  and the cluster that they will be deployed on.

### ECS Cluster - web (nginx / php-fpm)

* Creates an ECS Cluster for associating with ECS Service for EC2 instances running nginx 
  and php-fpm containers.
  
### Launch Configuration + Auto Scaling Group - web (nginx / php-fpm)
  
* Creates Launch Configuration to define EC2 instances used for hosting nginx and php-fpm
  containers and an Auto Scaling Group to define instance number.
  
### Task Definition + Service - web (nginx / php-fpm)
  
* Creates an ECS Task Definition which defines the containers and configuration that 
  will be deployed and an ECS Service which defines the desired number of containers
  and the cluster that they will be deployed on.  
  
### Record Set

* Creates a DNS entry within Route 53 for the API.
