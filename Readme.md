# Jitsi meet on ECS

## Introduction

This is a simple implementation of Jitsi meet deployment on AWS ECS.

For the purposes of jitsi meet, the ECS instance has been placed in the public subnet in order to be able to use a public IP required for the video stream.

To improve this, we could unbundle the JVB service into a new ECS service. But to do so, it will be necessary to have all containers communicate with each other. 

One solution would be to use AWS Discovery service. 


## AWS network architecture

![Drag Racing](images/diagram.jpg)

## Start the project

### Requirements
You need to install terraform (version >=0.12) on your laptop and create an AWS account.

### Run

1. You need to configure the `variables.tf` in the root directory.
2. Launch terraform with the following (don't forget to replace the variable content by your value)
```
terraform apply -var 'aws_access_key=my_access_key' -var 'aws_secret_key=my_secret_key' -var 'instance_keypair=my_keypair_name' -var 'domain_name=example.com'
```
3. You can access to jitsi on https://jitsi.example.com

### Logging
 All container logs are avaible on cloudwatch (log groups section)