#!/bin/bash -e

if [ "$1" == "eu-west-1a" ]
then
  dns_prefx=mongo-rs1
elif [ "$1" == "eu-west-1b" ]
then
    dns_prefx=mongo-rs2
elif [ "$1" == "eu-west-1c" ]
then
    dns_prefx=mongo-rs3
fi

change_batch="{\"Changes\":[{\"Action\":\"UPSERT\",\"ResourceRecordSet\":{\"Name\":\"${dns_prefx}.internal.synaptology.net.\",\"Type\": \"A\",\"TTL\": 300,\"ResourceRecords\":[{\"Value\": \"${2}\"}]}}]}"

echo ${change_batch} > change-batch.json

aws route53 change-resource-record-sets --hosted-zone-id ${3} --change-batch file://change-batch.json
