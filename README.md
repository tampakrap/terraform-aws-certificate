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

## Outputs

| Name | Description |
|------|-------------|
| arn | The certificate ARN. If the domains map is empty, it will be set to an empty string. |

## License

MIT
