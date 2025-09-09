The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

instance scheduler

stop EC2 or RDS instances during a scheduled period of time to optimize for cost
example use 

.tf 
module "instance-scheduler" {
  source     = "git::https://gitlab.itgix.com/itgix-public/terraform-modules/instance-scheduler.git"
  count      = var.instance_scheduler_enabled ? 1 : 0
  start_time = var.start_time
  stop_time  = var.stop_time
  timezone   = var.timezone
}

.tfvars
instance_scheduler_enabled = true
start_time                 = "cron(0 9 ? * MON-FRI *)"
stop_time                  = "cron(0 18 ? * MON-FRI *)"
timezone                   = "EET"


Resources that are to be stopped or started by the scheduler should be tagged : 

AutoOn = true

or

AutoOn = false

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.iam_policy_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_policy_to_scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.lambda_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_scheduler_schedule.start-ec2-schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.stop-ec2-schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [archive_file.zip_the_python_code1](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.zip_the_python_code2](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_start_time"></a> [start\_time](#input\_start\_time) | Cronjob time for the instances start | `string` | n/a | yes |
| <a name="input_stop_time"></a> [stop\_time](#input\_stop\_time) | Cronjob time for the instances stop | `string` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Time zone | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
