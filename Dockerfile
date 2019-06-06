FROM python:3.7

ENV IP_ADDRESS "127.0.0.1"
ENV SSH_USER "root"
ENV SSH_KEY "key"
ENV COMMAND "uname -a"
RUN mkdir /temp
COPY ./lambda/command/code/ec2_execute_command.py /temp/ec2_execute_command.py

RUN pip3 install paramiko && \
    pip3 install boto3 && \
    pip3 install cryptography==2.4.2

RUN chmod +x /temp/ec2_execute_command.py

RUN mkdir -p ~/.ssh/ && touch ~/.ssh/known_hosts

CMD python /temp/ec2_execute_command.py
