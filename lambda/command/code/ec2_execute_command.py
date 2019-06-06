"""
- Executes a command on an EC2 instance
"""
import os
from io import StringIO
import paramiko
import boto3
import logging

INSTANCEID = os.environ.get('INSTANCE_ID')
IPADDR = os.environ.get('IP_ADDRESS')
SSHUSER = os.environ.get('SSH_USER')
SSHKEY = os.environ.get('SSH_KEY')
COMMAND = os.environ.get('COMMAND')
SLACK_WEBHOOK = os.environ.get('SLACK_WEBHOOK')

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.DEBUG)

def get_ec2_instance_ip_from_id(instanceid):
    """
    - Get's the instance IP from the instance ID provided by Terraform
    """
    LOGGER.info('Getting EC2 instance IP from ID...')
    try:
        ec2 = boto3.client('ec2')
        host = ec2.describe_instances(InstanceIds=[instanceid])['Reservations'][0]['Instances'][0]['PrivateIpAddress']
        return host
    except:
        LOGGER.error('Failed to get EC2 instance IP!')
        sys.exit(1)

def run_ec2_command(host, sshuser, sshkey, command):
    """
    - Create SSH connection and execute command
    """
    LOGGER.info('Creating SSH connnection...')
    try:
        ssh_key_string = StringIO(sshkey)
        private_key = paramiko.RSAKey.from_private_key(ssh_key_string)
        ssh = paramiko.SSHClient()
        ssh.load_host_keys(os.path.expanduser('~/.ssh/known_hosts'))
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(host, username=sshuser, pkey=private_key)
        stdin, stdout, stderr = ssh.exec_command(str(command))
        result = stdout.read().decode('ascii').strip("\n")
        LOGGER.info('The server returned the following:\n' + result)
        ssh.close()
    except Exception as err:
        LOGGER.error('SSH connection failed. Error:-\n' + err)
        error = str(err)
        send_message_to_slack(error)
        sys.exit(1)

def send_message_to_slack(text):
    """
    Formats the text and posts to a specific Slack web app's URL
    Returns:
        Slack API repsonse
    """
    try:
        post = {
            "text": ":fire: :sad_parrot: An error has occured in the *OAG* pod :sad_parrot: :fire:",
            "attachments": [
                {
                    "text": "{0}".format(text),
                    "color": "#B22222",
                    "attachment_type": "default",
                    "fields": [
                        {
                            "title": "Priority",
                            "value": "High",
                            "short": "false"
                        }
                    ],
                    "footer": "Kubernetes API",
                    "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png"
                }
            ]
            }
        json_data = json.dumps(post)
        req = urllib.request.Request(url=SLACK_WEBHOOK,
                                     data=json_data.encode('utf-8'),
                                     headers={'Content-Type': 'application/json'})
        resp = urllib.request.urlopen(req)
        return resp
    except Exception as err:
        LOGGER.error(
            'The following error has occurred on line: %s',
            sys.exc_info()[2].tb_lineno)
        sys.exit(1)


def main():
    """
    - Run it!
    """
    LOGGER.info('Starting...')
    if INSTANCEID:
        get_ec2_instance_ip_from_id(INSTANCEID)
        run_ec2_command(host, SSHUSER, SSHKEY, COMMAND)
    else:
        host = IPADDR
        run_ec2_command(host, SSHUSER, SSHKEY, COMMAND)
    LOGGER.info("We're done here")

if __name__ == '__main__':
    main()
