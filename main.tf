# Beanstalk Application
resource "aws_elastic_beanstalk_application" "main" {
  name        = "${var.application_name}"
  description = "${var.application_description}"
}

# Production environment with basic configuration
resource "aws_elastic_beanstalk_environment" "production" {
  name                = "${var.application_name}-prod-env"
  application         = "${aws_elastic_beanstalk_application.main.name}"
  solution_stack_name = "${var.solution_stack_name}"
  tier                = "WebServer"

  # All settings: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "${var.autoscaling_min_size}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.autoscaling_max_size}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:php:phpini"
    name      = "document_root"
    value     = "${var.application_document_root}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "30"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"
  }

  setting {
    namespace = "aws:elb:policies"
    name      = "ConnectionDrainingEnabled"
    value     = "${var.lb_connection_draining}"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "${var.lb_cross_zone}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "aws-elasticbeanstalk-service-role"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SSHSourceRestriction"
    value     = "tcp,22,22,${var.private_cidr}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "ImageId"
    value     = "ami-8f3024e9"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "common_ssh_key"
  }

  # Autoscaling settings
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "10"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "80"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  # Public subnets - used for EC2 instances facing traffic from internet
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    # value     = "subnet-05de104c,subnet-c5fd3ea2,subnet-3af4fb62"
    value     = "${join(",", var.ec2_subnets)}"
  }

  # Subnets ELB will connect to
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    # value     = "subnet-05de104c,subnet-c5fd3ea2,subnet-3af4fb62"
    value     = "${join(",", var.lb_subnets)}"
  }

  # Assign public IP address to EC2 instances
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }
}
