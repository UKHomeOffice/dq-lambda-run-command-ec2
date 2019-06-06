# pylint: disable=missing-docstring, line-too-long, protected-access, E1101, C0202, E0602, W0109
import unittest
import hashlib
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """
            provider "aws" {
              region = "eu-west-2"
              profile = "foo"
              skip_credentials_validation = true
              skip_get_ec2_platforms = true
            }
            module "root_modules" {
              source = "./mymodule"
              providers = {aws = "aws"}
              namespace          = "dq-test"
              naming_suffix      = "preprod"
              path_module        = "unset"
              instance_id        = "i-1234567890"
              ip_address         = "10.1.1.1"
              ssh_user           = "my-user"
              command            = "uname -a"
              lambda_subnet      = "10.1.1.1/24"
              lambda_subnet_az2  = "10.1.1.1/24"
              security_group_ids = "sg-1234567890"
              count_tag          = "0"
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_name_suffix_ops_pipeline_iam_lambda_reconcile(self):
        self.assertEqual(self.result['root_modules']["aws_lambda_function.lambda_run_ec2_command"]["tags.Name"], "lambda-ec2-command-run-preprod")


if __name__ == '__main__':
    unittest.main()
