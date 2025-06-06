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
