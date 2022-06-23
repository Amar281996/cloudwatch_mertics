terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
provider "aws" {
    region = var.aws-region
    profile = var.aws-profile
}
resource "aws_vpc" "Itaxvpc" {
    cidr_block = var.vpc-cidr 
    tags = {
        Name = "fithealth"
    }
}
resource "aws_subnet" "privatesub1" {
    vpc_id = aws_vpc.Itaxvpc.id
    cidr_block = "10.0.3.0/24"
    }
resource "aws_security_group" "itsshsg" {
        vpc_id = aws_vpc.Itaxvpc.id
          ingress {
              
              from_port = 22
              to_port = 22
              protocol = "tcp"
              cidr_blocks = ["0.0.0.0/0"]
           }
           egress {
               from_port = 8080
               to_port = 8081
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
           }   
     }  
     resource "aws_internet_gateway" "It_ig" {
               vpc_id = aws_vpc.Itaxvpc.id
              tags = {
                Name = "It_ig"  
         }
     } 
     resource "aws_route_table" "Itrt" {
    vpc_id = aws_vpc.Itaxvpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.It_ig.id
    }
 }
 resource "aws_route_table_association" "It_route_association" {
    route_table_id = aws_route_table.Itrt.id
    subnet_id = aws_subnet.privatesub1.id
 }
resource "aws_instance" "mycloudwatchec2" {
    subnet_id = aws_subnet.privatesub1.id
    vpc_security_group_ids = [aws_security_group.itsshsg.id]
    instance_type = var.instance-type
    ami = "ami-052efd3df9dad4825"
}
resource "aws_cloudwatch_metric_alarm" "fithealth" {
  alarm_name                = "terraform-fithealthapp_alaram"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors ec2 cpu utilizations"
  insufficient_data_actions = []

  dimensions = {
       Instance_Id = aws_instance.mycloudwatchec2.id
     }
}