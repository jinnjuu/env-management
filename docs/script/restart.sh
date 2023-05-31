#!/bin/bash

region=$(aws configure get region)
#echo region=$region

clusters=$(aws ecs list-clusters --region $region --query 'clusterArns[*]' --output text | tr "/" "\n")
cluster=$(aws ecs describe-clusters --clusters $clusters --query 'clusters[0].clusterName' --output text)
#echo cluster=$cluster

services=$(aws ecs list-services --region $region --cluster env-mgmt-cluster --query 'serviceArns[*]' --output text | tr "/" "\n" | awk 'NR==3')
service=$(aws ecs describe-services --cluster $cluster --services $services --query 'services[0].serviceName' --output text)
#echo service=$service

tasks=$(aws ecs list-tasks --region $region --cluster $cluster --service $service --query 'taskArns[*]' --output text | tr "/" "\n" | awk 'NR==3')
task=$(echo $tasks | cut -d' ' -f1)
#echo task=$task

logGroupName="/ecs/$cluster/$service"
#echo logGroupName=$logGroupName

logStreamName=$(aws logs describe-log-streams --log-group-name $logGroupName --order-by LastEventTime --descending --query "logStreams[0].logStreamName" --output text)
#echo logStreamName=$logStreamName

aws ecs stop-task --cluster $cluster --task $task --region $region > /dev/null
echo ===== Stopped task: $task =====