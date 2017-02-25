# VPC and Subnets

## vpc.template

### Overview
This CloudFormation template:
* creates a VPC
* attaches an Internet Gateway
* creates and associates Network Acl rules 
* creates and associates Route rules

Note that if this template is run in a region in which there is no *(main) Route Table*, *(default) Security Group* or
*(default) Network Acl* that the act of creating the VPC will create these entities in addition to any Route Table(s), Security Group(s) or 
Network Acl(s) defined in the template.

### Summary 
* VPC
    * Internet Gateway
        * provides access to internet
        * attached to VPC via VPC Gateway Attachment
    * Network Acl (optional)
        * provides rules for inbound and outbound traffic (defined in Network Acl Entry)
        * can be applied to VPC or subnet
    * Route Table
        * provides routing rules (defined in Route entries)
        * can be applied to VPC or subnet
    
### Resources

#### InternetGateway - AWS::EC2::InternetGateway
Required to enable access to or from the Internet for instances in a VPC subnet 
(see [docs](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Internet_Gateway.html)).

#### NetworkAcl - AWS::EC2::NetworkAcl
Optional, applies additional rules for ingress and egress from VPC.

#### NetworkAclEntryEgress - AWS::EC2::NetworkAclEntry
Network ACL rule for outbound traffic.

#### NetworkAclEntryIngress - AWS::EC2::NetworkAclEntry
Network ACL rule for inbound traffic.

#### Route - AWS::EC2::Route
Route within a route table within a VPC. Targets either an Internet
or NAT Gateway.

#### RouteTable - AWS::EC2::RouteTable
Entity for storing routes associated with a VPC.

#### VPC - AWS::EC2::VPC
Virtual Private Cloud with CIDR block as specified.

#### VPCGatewayAttachment - AWS::EC2::VPCGatewayAttachment
Attaches gateway to VPC.


