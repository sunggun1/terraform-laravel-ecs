resource "aws_ecs_capacity_provider" "cp"{
    name = "laravel-cp-${random_string.random.result}"

    auto_scaling_group_provider{
        auto_scaling_group_arn = aws_autoscaling_group.asg.arn
        managed_termination_protection = "ENABLED"

        managed_scaling {
            maximum_scaling_step_size = 3
            minimum_scaling_step_size = 1
            status                    = "ENABLED"
            target_capacity           = 100
        }
    }
}