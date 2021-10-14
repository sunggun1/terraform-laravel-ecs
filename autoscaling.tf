resource "aws_autoscaling_group" "asg" {
  #availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
  name = "asg"
  desired_capacity   = 3
  max_size           = 3
  min_size           = 0
  health_check_type  = "EC2"
  health_check_grace_period = 300

  launch_configuration = aws_launch_configuration.launchConfig.name

  vpc_zone_identifier = concat(slice(module.vpc.public_subnets, 0, 1),slice(module.vpc.public_subnets, 2, 3))
  force_delete = true
  protect_from_scale_in = true

  lifecycle {
    create_before_destroy = true
  }

}