# dq-lambda-run-command-ec2

## Introduction
This Terraform module creates a Lambda function that runs a Python script that executes a command on an EC2 instance.

## Usage
The module is intended to be called by a parent repository, as it requires some variables to be passed in.

### Variables
| Variable  | Description |
|-----------|-------------|
| namespace | The name of the AWS account (NotProd / Prod) |
| instance_id | The ID of the instance to connect to |
| ip_address | (Optional) Will be used if instance_id is not set |
| ssh_user | The user that the script will use to connect |
| command | The command to be run on the remote server |
| naming_suffix | The naming suffix (...apps-notprod-dq). This is commonly passed in from the Terraform repo that is pulling in the module |
| slack_webook | Slack webhook for notifications |

### Example Usage
```
module "lambda_run_ec2_command" {
  namespace     = "preprod"
  instance_id   = "i-123456789"
  ssh_user      = "root"
  command       = "uname -a"
}
```
