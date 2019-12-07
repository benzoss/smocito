#!/bin/bash
declare -a ami=(ami-04b9e92b5572fa0d1 ami-0d5d9d301c853a04a ami-0dd655843c87b6930 ami-06d51e91cea0dac8d)
declare -a region=(us-east-1 us-east-2 us-west-1 us-west-2)
for m in $(seq 10000); do
for i in $(seq 4); do
t=$((i-1))
aws ec2 run-instances --image-id ${ami[t]} --count 2 --instance-type t2.medium --region ${region[t]}  --user-data file://cdata.txt
done
sleep 1700
for i in $(seq 4); do
t=$((i-1))
instances=$(aws ec2 describe-instances   --query "Reservations[*].Instances[*].InstanceId"  --filters "Name=instance-state-name,Values=running" --output=text --region ${region[t]})
for instance in $instances; do
aws ec2 terminate-instances --instance-ids --instance-id $instance --region  ${region[t]}
done
done
sleep 120
done
