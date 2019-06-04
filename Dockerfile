FROM python:3.7

ENV ip_address "127.0.0.1"
ENV ssh_user "root"
ENV ssh_key "key"
ENV COMMAND "uname -a"

COPY ./lambda/command/code/ec2_execute_command.py /tmp/ec2_execute_command.py

RUN pip3 install paramiko && \
    pip3 install boto3

RUN chmod +x /tmp/ec2_execute_command.py

CMD python /tmp/ec2_execute_command.py
