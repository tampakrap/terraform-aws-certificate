output "arn" {
  value       = element(concat(aws_acm_certificate_validation.cert_validation.*.certificate_arn, local.EMPTY_LIST), 0)
  description = "The certificate ARN. If the domains map is empty, it will be set to an empty string."
}

output "domain_validation_options" {
  value       = aws_acm_certificate.cert.0.domain_validation_options
  description = "A map of all the domain validation options of the certificate."
}

output "main_domain" {
  value       = local.domain
  description = "The main domain of the certificate."
}

output "subject_alternative_names" {
  value       = local.subject_alternative_names
  description = "The Subject Alternative Names of the certificate."
}

output "domains" {
  value       = concat(list(local.domain), local.subject_alternative_names)
  description = "A list of all the domains of the certificate."
}

output "zone_ids" {
  value       = data.aws_route53_zone.zone.*.id
  description = "A list of all the zone IDs."
}

output "zone_names" {
  value       = data.aws_route53_zone.zone.*.name
  description = "A list of all the zone names."
}
