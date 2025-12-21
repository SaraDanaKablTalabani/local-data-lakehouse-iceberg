#!/bin/bash
echo "Start to download the jar packages"

cp "/root/gravitino/packages/hadoop-aws-3.3.1.jar" /root/gravitino/iceberg-rest-server/libs
cp "/root/gravitino/packages/hadoop-aws-3.3.1.jar" /root/gravitino/catalogs/lakehouse-iceberg/libs

cp "/root/gravitino/packages/aws-java-sdk-bundle-1.11.901.jar" /root/gravitino/iceberg-rest-server/libs
cp "/root/gravitino/packages/aws-java-sdk-bundle-1.11.901.jar" /root/gravitino/catalogs/lakehouse-iceberg/libs

# Copy all of the configuration in their respective folders
cp /tmp/conf/gravitino.conf /root/gravitino/conf/gravitino.conf
cp /tmp/conf/core-site.xml /root/gravitino/conf/core-site.xml
cp /tmp/conf/core-site.xml /root/gravitino/iceberg-rest-server/conf/core-site.xml

echo "Finish downloading"
echo "Start the Gravitino Server"
/bin/bash /root/gravitino/bin/gravitino.sh start &
sleep 3
tail -f /root/gravitino/logs/gravitino-server.log