#!/bin/bash -e

if [[ -z "$ACCESS_KEY_ID" ]]; then
  echo "Please set ACCESS_KEY_ID"
  exit -1
fi

if [[ -z "$SECRET_ACCESS_KEY" ]]; then
  echo "Please set SECRET_ACCESS_KEY"
  exit -1
fi

if [[ -z "$REGION" ]]; then
  echo "Please set REGION"
  exit -1
fi

if [[ -z "$VOLUMES" ]]; then
  echo "Please set VOLUMES"
  exit -1
fi

IFS=';' read -ra watching_volumes <<< "$VOLUMES"
for volume in "${watching_volumes[@]}"
do
  automated-ebs-snapshots --access-key-id $ACCESS_KEY_ID --secret-access-key $SECRET_ACCESS_KEY --region $REGION --watch $volume --retention 96 --interval hourly
done

while true; do
  automated-ebs-snapshots --access-key-id $ACCESS_KEY_ID --secret-access-key $SECRET_ACCESS_KEY --region $REGION --run
  sleep 600
done
