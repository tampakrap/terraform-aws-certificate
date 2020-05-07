provider "aws" {
  alias  = "acm"
}

resource "aws_acm_certificate" "cert" {
  count                     = local.validations_needed > 0 ? 1 : 0
  domain_name               = local.domain
  subject_alternative_names = local.subject_alternative_names
  validation_method         = "DNS"
  provider                  = aws.acm

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

data "aws_route53_zone" "zone" {
  count = length(local.zones)
  name  = local.zones[count.index]
}

resource "aws_route53_record" "records" {
  // A better option would've been
  // count = length(aws_acm_certificate.cert.domain_validation_options)
  // but it will error out with a 'value of 'count' cannot be computed' on a clean build.
  // It seems like this will be solved with HCL2
  // * https://github.com/hashicorp/terraform/issues/17421
  count = local.validations_needed

  name = lookup(local.unique_domain_validation_options[count.index], "resource_record_name")
  type = lookup(local.unique_domain_validation_options[count.index], "resource_record_type")

  // It basically reverses the zone_name from the domain_name, then the zone_id from the zone_name.
  zone_id = element(matchkeys(
    data.aws_route53_zone.zone.*.id,
    data.aws_route53_zone.zone.*.name,
    local.record_map[lookup(local.unique_domain_validation_options[count.index], "domain_name")]
  ), 0)

  records = [
    lookup(local.unique_domain_validation_options[count.index], "resource_record_value"),
  ]

  ttl = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  count           = local.validations_needed > 0 ? 1 : 0
  certificate_arn = aws_acm_certificate.cert.0.arn

  validation_record_fqdns = aws_route53_record.records.*.fqdn

  provider = aws.acm
}
