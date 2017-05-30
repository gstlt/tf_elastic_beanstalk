variable "application_name" {
  type = "string"
  description = "Beanstalk application name"
}

variable "application_environment" {
  type = "string"
  description = "Environment: dev, prod, qa"
  default = "prod"
}

variable "application_description" {
  type = "string"
  description = "Application description"
  default = ""
}

variable "solution_stack_name" {
  type = "string"
  description = "Solution stack name we will use"
  default = "64bit Amazon Linux 2017.03 v2.4.0 running PHP 7.0"
}

variable "instance_type" {
  type = "string"
  description = "Default instance type for the application"
  default = "t2.micro"
}

# Networking
variable "vpc_id" {
  type = "string"
  description = "VPC ID we will run our application"
}

variable "ec2_subnets" {
  type = "list"
  description = "Subnets for EC2 use"
}

variable "lb_subnets" {
  type = "list"
  description = "Subnets for ELB"
}

variable "private_cidr" {
  type = "string"
  description = "Private CIDR for SSH access"
}

variable "autoscaling_min_size" {
  type = "string"
  description = "Minimum size of the autoscaling group"
  default = "1"
}

variable "autoscaling_max_size" {
  type = "string"
  description = "Maximum size of the autoscaling group"
  default = "1"
}

variable "lb_connection_draining" {
  type = "string"
  description = "Enable or disable connection draining (true/false)"
  default = "true"
}

variable "lb_cross_zone" {
  type = "string"
  description = "Set cross-zone load balancing"
  default = "true"
}

variable "application_document_root" {
  type = "string"
  description = "Document root relative to main project directory, eg. it could be /web if your main index.php resides in web subdirectory"
  default = "/"
}

