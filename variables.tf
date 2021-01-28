variable "default_region" {
    type = string
    description = "The default region to using in the code."
    default = "us-east-1"
}

variable "ami_owner" {
    type = string
    description = "The AMI owner ID. The deafult is Canonical"
    default = "099720109477"
}

variable "ami_name_filter" {
    type = string
    description = "The name for looking for a instance"
    default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "ec2_size_type" {
    type = string
    description = "The kind of size to use in instances"
    default = "t2.micro"
}

variable "ec2_name" {
    type = string
    description = "The name to EC2"
    default = "ec2-app"
}

variable "letters_to_zone" {
    type = list(string)
    description = "Letters used to specify the AZ from region."
    default = ["a","b","c"]
}

variable "key_pair_name" {
    type = string
    description = "If necessary to use a key pair to SSH access."
    default = ""
}

variable "s3_name" {
    type = string
    description = "S3 name that EC2 will access."
}

variable "aws_account_id" {
    type = string
    description = "AWS account ID to build ARN string for grant access."
}

variable "count_instance" {
  type = string
  description = "The total instance."
  default = ""
}

variable "asg_max_size" {
  type = number
  description = "The max number of instance in ASG."
  default = 3
}

variable "asg_min_size" {
  type = number
  description = "The max number of instance in ASG."
  default = 1
}

variable "asg_desired_size" {
  type = number
  description = "The desired number of instance in ASG."
  default = 1
}