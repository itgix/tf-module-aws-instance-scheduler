# IAM Role for  lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_start_stop"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for logging from a lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
               "rds:DescribeDBInstances",
               "rds:ListTagsForResource",
               "rds:StopDBInstance",
               "rds:StartDBInstance",
               "ec2:DescribeInstances",
               "ec2:StopInstances",
               "ec2:StartInstances"
                ],

            "Resource": "*"

        }
    ]
}
EOF
}


# Policy Attachment on the role.
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Generates an archive from content, a file, or a directory of files.

data "archive_file" "zip_the_python_code1" {
  type        = "zip"
  source_dir  = "${path.module}/python/start/"
  output_path = "${path.module}/python/start/start.zip"
}

# Create a lambda functions
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "lambda_start" {
  filename      = "${path.module}/python/start/start.zip"
  function_name = "start"
  role          = aws_iam_role.lambda_role.arn
  handler       = "start.lambda_handler"
  runtime       = "python3.10"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]

  tags = {
    ManagedBy   = "Terraform"
    Project     = "project"
    Environment = "dev"
    CostCenter  = "n/a"
    Application = "all"
  }
}

data "archive_file" "zip_the_python_code2" {
  type        = "zip"
  source_dir  = "${path.module}/python/stop/"
  output_path = "${path.module}/python/stop/stop.zip"
}
resource "aws_lambda_function" "lambda_stop" {
  filename      = "${path.module}/python/stop/stop.zip"
  function_name = "stop"
  role          = aws_iam_role.lambda_role.arn
  handler       = "stop.lambda_handler"
  runtime       = "python3.10"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]


  tags = {
    ManagedBy   = "Terraform"
    Project     = "project"
    Environment = "dev"
    CostCenter  = "n/a"
    Application = "all"
  }
}
# IAM Role for Scheduler
resource "aws_iam_role" "scheduler" {
  name = "cron-scheduler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "events.amazonaws.com",
            "lambda.amazonaws.com",
            "scheduler.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM policy for Scheduler
resource "aws_iam_policy" "scheduler_policy" {
  name        = "scheduler_policy"
  description = "A policy to allow scheduler to start and stop EC2 instances"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = "*"
      },
    ]
  })
}

# Policy Attachment on the role.
resource "aws_iam_role_policy_attachment" "attach_policy_to_scheduler" {
  policy_arn = aws_iam_policy.scheduler_policy.arn
  role       = aws_iam_role.scheduler.name
}

resource "aws_scheduler_schedule" "start-ec2-schedule" {
  name        = "start-instances"
  description = "Start Instances at a provided time"

  schedule_expression          = var.start_time
  schedule_expression_timezone = var.timezone
  flexible_time_window {
    mode = "OFF"
  }
  target {
    role_arn = aws_iam_role.scheduler.arn
    arn      = aws_lambda_function.lambda_start.arn
  }
}

resource "aws_scheduler_schedule" "stop-ec2-schedule" {
  name        = "stop-instances"
  description = "Stop Instances at a provided time"


  schedule_expression          = var.stop_time
  schedule_expression_timezone = var.timezone

  flexible_time_window {
    mode = "OFF"
  }
  target {
    role_arn = aws_iam_role.scheduler.arn
    arn      = aws_lambda_function.lambda_stop.arn
  }
}
