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

variable "health_check_interval" {
  type = number
  description = "Amount in sec of interval between checks."
  default = 35
}

variable "health_check_timeout" {
  type = string
  description = "Amount in sec of timeout for each checks."
  default = 30
}

variable "threshold_scale_in" {
    type = string
    description = "The number represented in percent to alarm trigger scale-in ASG instances."
    default = "80"
}

variable "threshold_scale_out" {
    type = string
    description = "The number represented in percent to alarm trigger scale-out ASG instances."
    default = "60"
}