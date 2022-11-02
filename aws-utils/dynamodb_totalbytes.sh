#!/usr/bin/env bash

timestamp=$(date +"%m%d%Y_%T")
reportFile="dynamodb_size_${timestamp}.csv"

echo 'Region, TableName, Size' | awk '{printf "%-17s %-47s %-20s\n", $1, $2, $3}' > ./$reportFile;

for REGION in 'us-east-1' 'us-east-2' 'eu-central-1' 'ap-northeast-1' 'ap-southeast-2'; do
  regionTables=$(aws dynamodb list-tables --region $REGION | jq -c '.TableNames' | sed -E 's/[][",]/ /g')
  for TABLE in $regionTables; do
      echo $TABLE
      tableSizeBytes=$(aws dynamodb describe-table --table-name $TABLE --region $REGION | jq -r '.Table.TableSizeBytes');
      echo "${REGION}, ${TABLE}, ${tableSizeBytes}" >> ./$reportFile;
  done
done
