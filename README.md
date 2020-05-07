# Terraform Certificate

*This terraform module is maintained by [Media Pop](https://www.mediapop.co), a software consultancy. Hire us to solve your DevOps challenges.*

Create and automatically verify a certificate across one or many zones. CloudFront enabled (us-east-1).

# Usage

You can specify as many zones and records as you wish following this simple format:

```hcl
module "cert" {
  source = "mediapop/certificate/aws"

  domains = {
    "zone-name.com." = ["record.zone-name.com"]
    "mediapop.co."   = ["mediapop.co", "*.mediapop.co"]
  }
}

resource "aws_cloudfront_distribution" "redirect" {
  viewer_certificate {
    acm_certificate_arn = module.cert.arn

    // ...
  }

  // ...
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| aws.acm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domains | A map {"zone.com." = ["zone.com","www.zone.com"],"foo.com" = ["foo.com"] } of domains. | `map(list(string))` | n/a | yes |
| main\_domain | (Optional) The main domain of the certificate | `string` | `""` | no |
| tags | (Optional) Tags for the certificate | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The certificate ARN. If the domains map is empty, it will be set to an empty string. |
| domain\_validation\_options | A list of maps of all the domain validation options of the certificate. |
| domains | A list of all the domains of the certificate. |
| main\_domain | The main domain of the certificate. |
| subject\_alternative\_names | The Subject Alternative Names of the certificate. |
| unique\_domain\_validation\_options | A list of maps of the unique domain validation options of the certificate. |
| zone\_ids | A list of all the zone IDs. |
| zone\_names | A list of all the zone names. |

## License

MIT
