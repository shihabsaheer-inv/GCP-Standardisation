#Common variables
region     = "us-central1"
env_name   = "staging-new"
project_id = "terraform-setup-476004"
zone       = "us-central1-a"


# Toggles for enabling and disbaling modules
enable_vpc = true


#vpc
vpc_name             = "staging-vpc"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
