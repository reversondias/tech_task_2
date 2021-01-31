# Tech Task 1
In this task cover the bellow down topics:  
- Add the created instances under the auto scaling group.
- Write a life cycle policy with the following parameters:
        scale in : CPU utilization > 80%
        scale out : CPU Utilization < 60%

## [ATTENTION] Important information about versions
- Terraform version: **0.12.20**  
- AWS provider version: **3.25.0**  

## Aboute S3 access
This code was made thinking to allow full access in only one S3 bucket. Then is necessary declare the name of S3 bucket.  
If necessary grant access for all S3 buckets, use **\***.    

## Variables
Almost of variables used in this code has default values.  
In the *variables.tf* file there are short descriptions aboute each variable.  

Variables with default values:  
- default_region: default = "us-east-1"  
- ami_owner: default = "099720109477"  
- ami_name_filter: default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"  
- ec2_size_type: default = "t2.micro"  
- letters_to_zone: default = ["a","b","c"]  
- key_pair_name: default = ""  
- asg_max_size: default = 3  
- asg_min_size: default = 1  
- health_check_interval: default = 35  
- health_check_timeout: default = 30  
- threshold_scale_in: default = "80"  
- threshold_scale_out: default = "60"  

Have to declare:  
- s3_name: S3 bucket name to create a policy role in AWS IAM  

**[IMPORTANT]** - Two variables it is important to say:  
- **key_pair_name**: Used to set a SSH key pair to access the instance if it wish.  


In the repository there is a *vars.tfvars* file as a exemple variables file to use with terraform code.  