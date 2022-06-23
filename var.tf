variable "aws-region" {
    type = string
    description = " provisioned cloudwatch alaram metrics on this region"
     default = "us-east-1"
}
variable "aws-profile" {
    type = string
    description = "user credentials"
    default = "default"
}
variable "vpc-cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "instance-type" {
    type = string
    description = "which type of instance"
    default = "t2.micro"
}
variable "ami" {
 type = string
 default = "ami-0cff7528ff583bf9a"
 }