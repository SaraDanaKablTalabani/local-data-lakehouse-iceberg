#!/bin/bash
# =======================================================================
# Load common functions
# =======================================================================
. "/root/gravitino/common/common.sh"

# =======================================================================
# Prepare target directory for packages
# =======================================================================
target_dir="/root/gravitino"
if [[ ! -d "${target_dir}/packages" ]]; then
  mkdir -p "${target_dir}/packages"
fi

# =======================================================================
# Download Necessary JAR and MD5
# =======================================================================
HADOOP_AWS_JAR="https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.1/hadoop-aws-3.3.1.jar"
HADOOP_AWS_MD5="${HADOOP_AWS_JAR}.md5"
download_and_verify "${HADOOP_AWS_JAR}" "${HADOOP_AWS_MD5}" ${target_dir}

AWS_JAVA_SDK_BUNDLE_JAR="https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.901/aws-java-sdk-bundle-1.11.901.jar"
AWS_JAVA_SDK_BUNDLE_MD5="${AWS_JAVA_SDK_BUNDLE_JAR}.md5"
download_and_verify "${AWS_JAVA_SDK_BUNDLE_JAR}" "${AWS_JAVA_SDK_BUNDLE_MD5}" ${target_dir}