# VPC and Subnets

## vpc.template

### Overview
This CloudFormation template:
* creates a VPC
* attaches an Internet Gateway
* creates and associates Network Acl rules 
* creates and associates Route rules

__Note__ - running this template in a region which does not contain the following will create these resources:
* (main) Route Table
* (default) Security Group
* (default) Network Acl 

### Summary 
* VPC
    * Internet Gateway
        * provides access to internet
        * attached to VPC via VPC Gateway Attachment
    * Network Acl (optional)
        * provides rules for inbound and outbound subnet traffic (defined in Network Acl Entry)
        * associated with VPC
    * Route Table
        * provides routing rules (defined in Route entries)
        * associated with VPC
    
__Note__ - the Network Acl and Route Table created in this template are not used here but are set-up as a convenience for use by the subnet templates.
* Network Acl in this case allows all types (protocol = -1) of traffic (e.g., ssh, tcp) to/from any address (0.0.0.0/0)
* Route Table is set-up so that traffic originating from within subnet destined for any address (0.0.0.0/0) will be directed to the Internet Gateway    
    
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


