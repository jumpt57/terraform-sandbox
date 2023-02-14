# resource "aws_route53_zone" "primary" {
#   count = var.create_dns_zone ? 1 : 0
#   name = var.domain
# }

data "aws_route53_zone" "primary" {
  # count = var.create_dns_zone ? 0 : 1
  name  = var.domain
}

locals {
  # dns_zone_id = var.create_dns_zone ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.primary[0].zone_id
  subdomain   = var.environment_name == "production" ? "" : "${var.environment_name}."
  # name_servers = var.create_dns_zone ? aws_route53_zone.primary[0].name_servers : data.aws_route53_zone.primary[0].name_servers
}

resource "aws_route53_record" "root" {
  name    = "${local.subdomain}${var.domain}"
  type    = "A"
  # zone_id = local.dns_zone_id
  zone_id = data.aws_route53_zone.primary.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
  }
}

# resource "aws_route53domains_registered_domain" "jumpt57_link" {
#   domain_name = var.domain

#   dynamic "name_server" {
#     for_each = sort(local.name_servers)
#     content {
#       name = name_server.value
#     }
#   }
# }
