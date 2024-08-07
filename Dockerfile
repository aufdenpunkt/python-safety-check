# Container image that runs your code
FROM python:latest

# Install python safety package
RUN pip install --upgrade pip && pip install safety

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
