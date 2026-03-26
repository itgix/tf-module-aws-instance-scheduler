The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Instance Scheduler Terraform Module

This module deploys an instance scheduler using Lambda and EventBridge to automatically start and stop EC2 instances on a schedule.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- Lambda function for starting/stopping instances
- EventBridge rules for start and stop schedules
- IAM role and policies for Lambda execution

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `start_time` | Cron expression for instance start time | `string` | — | yes |
| `stop_time` | Cron expression for instance stop time | `string` | — | yes |
| `timezone` | Time zone for the schedule | `string` | — | yes |

## Usage Example

```hcl
module "instance_scheduler" {
  source = "path/to/tf-module-aws-instance-scheduler"

  start_time = "cron(0 8 ? * MON-FRI *)"
  stop_time  = "cron(0 18 ? * MON-FRI *)"
  timezone   = "Europe/Sofia"
}
```
