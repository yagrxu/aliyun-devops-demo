#!/bin/sh

len=$(aliyun vpc DescribeVpcs --RegionId eu-central-1 | jq '.Vpcs.Vpc | length')
if [ $len != 0 ]
then
    >&2 echo 'VPC not removed'
    exit 1
else
    echo 'VPC resource cleaned up'
fi