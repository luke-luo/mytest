# mytest

# Product Name

This application is to create a AWS infrastructure to run Nginx cluster. 

It creates a VPC with tag name "pdata", creates two EC2 instances that runs docker images for Nginx. 

It also creates an AWS ELB to connect to the two EC2 instances. 

Each EC2 instance by default runs a Nginx cluster that connects to docker containers running Nginx. By default the number of Nginx containers in a EC2 
instance is 2, you could change it by providing an input parameter when you execute the Terraform command, or change it use docker-compose command (Detail 
will be shown below)

Using the DNA name for the AWS ELB to you the results

## Usage example
To run this application, you should ensure the Terraform and AWS Cli has been installed in your machine and you should have privileges to create AWS resources.

There are two parameters:
number_nginx: default is 2, for number of Nginx container will be created in a EC2 istance
common_office_ip: default is 0.0.0.0/0, You should provide you IP that could access the AWS ELB DNS

Here is the command to create the infrastructure with 5 Nginx containers running in a Nginx cluster in a EC2 instance, and could be access from IP 123.123.123.123/32
```sh
cd terraform
terraform init
terraform apply -auto-approve -var="number_nginx=5" -var="common_office_ip=123.123.123.123/32"
```


## View output
The output will be like this:
```sh
Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

Outputs:

aws_elb_dns_name = pdata-elb-1619212053.us-east-1.elb.amazonaws.com
test_url = pdata-elb-1619212053.us-east-1.elb.amazonaws.com:8080
vpc_id = vpc-04890ef9630e20696

````

Get the output value "test_url" (e.g.: pdata-elb-1619212053.us-east-1.elb.amazonaws.com:8080) for the AWS ELB DNA name from the output of "terraform apply" command, and paste it to a web browser.

The page will show Docker container IPs into two Nginx clusters. 

Cluster name are "pdata-docker1" and "pdata-docker2". The cluster name is mapping to the EC2 instance tag "Name".

By refreshing the page, you will see the position changes in the page for the two cluster. The top one present the corresponding EC2  instance is picked by the AWS ELB

If you change the number of Nginx containers in a cluster, you will see the change by refreshing the page


## Change the number of Nginx on flight
You need to login to EC2 instance to change the number of containers in the cluster.
Use the ssh private key "pdata_test.pem" in folder "terrform/file" to login.

```
cd terraform/file
ssh -i pdata_test.pem ec2-user@EC2_PUBLIC_IP
```

Login to the EC2 instance to console,  and change the number of Nginx in the cluster. The example below changes the number to 10
```sh
cd ~/pdata/docker
docker-compose scale app=8
```


Refresh the page and it will show:
````
Cluster: pdata-docker1
172.18.0.7
172.18.0.6
172.18.0.4
172.18.0.5
172.18.0.2


Cluster: pdata-docker2
172.18.0.9
172.18.0.10
172.18.0.8
172.18.0.3
172.18.0.7
172.18.0.4
172.18.0.5
172.18.0.2
````


## To delete the environment
```sh
cd terraform
terraform destroy -auto-approve
```


## Notes:
Reboot the EC2 instance will restore the original number (The default (2) or the value of parameter number_nginx when creating the infrastructure) of Nginx in a cluster.


## How would this be configured to maximize availability
Upgrade the EC2 instance type to more powerful type.

Increase the number of containers in a Nginx cluster (base on the EC2 CPU utilization).

Use AWS Auto Scaling to enable the EC2 instances scale up and down base on CPU utilization and networks.

You could even use Route53 records to route the service to different regions.


## What loads would this spinup be able to handle.
EC2 CPU utilization

Network traffic load on AWS ELB

## How would logging, security be applied
Make EC2 instance in private network 
Remove public IP for EC2 instance (for this purpose I created jumper EC2 to access the private EC2 instance for deployment in future).

Use HTTPS for AWS ELB and apply SSL.

Limit the port open in security group for AWS ELB and EC2 instances.


An EFS has been created and mount to the EC2 instance in /home/ec2-user/efs, it is a volume in docker container foler /mydata. By this the host and containers could
communicate to each other. Logging data could be save in the EFS or to S3 (not implemented in this app)


 

 




