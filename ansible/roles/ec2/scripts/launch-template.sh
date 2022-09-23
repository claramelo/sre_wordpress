#!/bin/bash

aws ec2 create-image --instance-id {{ instance_id }} --name "Wordpess image" --description "An AMI for wordpress server"