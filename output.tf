output "ip"{
    description = "RDS instance hostname"
    value = aws_db_instance.default.address
}

output "fargate" {
    description = "fargate host name"
    value = aws_lb.demo.dns_name
}