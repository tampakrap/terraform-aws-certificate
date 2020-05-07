variable "main_domain" {
  type        = string
  description = "(Optional) The main domain of the certificate"
  default     = ""
}

variable "domains" {
  type        = map(list(string))
  description = "A map {\"zone.com.\" = [\"zone.com\",\"www.zone.com\"],\"foo.com\" = [\"foo.com\"] } of domains."
}

variable "tags" {
  type        = map
  description = "(Optional) Tags for the certificate"
  default     = {}
}

locals {
  zones = keys(var.domains)

  // We can't get the first index of an empty array, so we add a blank string element as a default so it doesn't blow
  // up when the domain map is empty.
  domain = var.main_domain != "" ? var.main_domain : element(concat(local.domains, local.EMPTY_LIST), 0)

  record_map = transpose(var.domains)
  domains    = compact(concat(keys(local.record_map), local.EMPTY_LIST))

  // We use this empty list to work around HCL limitations.
  EMPTY_LIST = [""]

  // *.example.org and example.org only needs 1 validation record. We need to unduplicate those domains
  // If domains {} is empty the list will become [""], so we need to compact it.
  validations_needed = length(compact(distinct(split(",", replace(join(",", local.domains), "*.", "")))))

  // Create a new list of maps of domain validation options, to remove the duplicates from the wildcard domains
  unique_domain_validation_options = [for item in aws_acm_certificate.cert.0.domain_validation_options: item if length(regexall("^\\*\\.", item["domain_name"])) == 0]

  subject_alternative_names = [for domain in local.domains: domain if domain != local.domain]
}
