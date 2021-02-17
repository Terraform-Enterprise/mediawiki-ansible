data "aws_route53_zone" "r53zone" {
  name = var.hosted_zone_name
}

resource "aws_route53_record" "mediawiki-domain-record" {
  zone_id = data.aws_route53_zone.r53zone.id
  name    = var.mediawiki_domain_name
  type    = "A"

  alias {
    name                   = aws_elb.mw_elb.dns_name
    zone_id                = aws_elb.mw_elb.zone_id
    evaluate_target_health = false
  }
}



output mediawiki_domain_fqdn {
  value       = aws_route53_record.mediawiki-domain-record.fqdn
}
