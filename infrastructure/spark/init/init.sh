#!/bin/bash
# Copy all of the downloaded jars to their respective folders
cp ./packages/iceberg-spark-runtime-3.5_2.12-1.10.0.jar /root/spark/jars/iceberg-spark-runtime-3.5_2.12-1.10.0.jar
cp ./packages/postgresql-42.7.0.jar /root/spark/jars/postgresql-42.7.0.jar
cp ./packages/hadoop-aws-3.3.1.jar /root/spark/jars/hadoop-aws-3.3.1.jar
cp ./packages/aws-java-sdk-bundle-1.11.901.jar /root/spark/jars/aws-java-sdk-bundle-1.11.901.jar

# Copy all of the configuration in their respective folders
cp /tmp/conf/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
cp /tmp/conf/core-site.xml ${SPARK_HOME}/conf/core-site.xml

# # Create metalake and catalog in Gravitino
sh /tmp/common/init_metalake_catalog.sh

# Run spark based on the workload type
SPARK_WORKLOAD=$1
echo "SPARK_WORKLOAD: $SPARK_WORKLOAD"
if [ "$SPARK_WORKLOAD" == "master" ];
then
    start-master.sh -p 7077
elif [ "$SPARK_WORKLOAD" == "worker" ];
then
    start-worker.sh spark://spark-master:7077
elif [ "$SPARK_WORKLOAD" == "history" ]
then
    start-history-server.sh
fi