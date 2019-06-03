"""
- Executes a command on an EC2 instance
"""
import os
from io import StringIO
import paramiko
import boto3


INSTANCEID = os.environ.get('instance_id')
SSHUSER = os.environ.get('ssh_user')
SSHKEY = os.environ.get('ssh_key')
COMMAND = os.environ.get('command')



def get_ec2_instance_ip_from_id(instanceid):
    """
    - Get's the instance IP from the instance ID provided by Terraform
    """
    ec2 = boto3.client('ec2')
    host = ec2.describe_instances(InstanceIds=[instanceid])['Reservations'][0]['Instances'][0]['PrivateIpAddress']
    return host

def run_ec2_command(sshuser, sshkey, command):
    """
    - Create SSH connection and execute command
    """
    #Convert string to dummy file type
    ssh_key_string = StringIO(sshkey)
    private_key = paramiko.RSAKey.from_private_key(ssh_key_string)
    ssh_key_string.close()

    #Make connection
    ssh = paramiko.SSHClient()
    ssh.connect(host, username=sshuser, pkey=private_key)
    (stdout) = ssh.exec_command(command)
    for line in stdout.readlines:
        print(line)
    ssh.close

def main():
    """
    - Run it!
    """
    get_ec2_instance_ip_from_id(INSTANCEID)
    run_ec2_command(SSHUSER, SSHKEY, COMMAND)
