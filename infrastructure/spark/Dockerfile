# Install Image with Python Version 3.10.11
FROM python:3.10.11-bullseye AS spark-base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    curl \
    vim \
    unzip \
    rsync \
    software-properties-common \
    openjdk-11-jdk \
    build-essential \
    ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*do

FROM spark-base AS spark

# =======================================================================
# Create folder for the Hadoop and Spark folders
# =======================================================================
ARG SPARK_VERSION=3.5.0
# RUN echo $SPARK_VERSION
ENV SPARK_HOME="/root/spark"
RUN mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}

# =======================================================================
# Install Standalone Spark
# =======================================================================
RUN curl https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o ${SPARK_HOME}/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && tar xvzf ${SPARK_HOME}/spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory ${SPARK_HOME} --strip-components 1 \
    && rm -rf ${SPARK_HOME}/spark-${SPARK_VERSION}-bin-hadoop3.tgz

FROM spark AS spark-deps
# =======================================================================
# Copy all initialization scripts
# =======================================================================
# Commmon initialization scripts
COPY ./infrastructure/common/ ./common/

# Spark initialization scripts
COPY ./infrastructure/spark/init/ ./init/
# =======================================================================
# Install Spark Dependencies 
# =======================================================================
RUN chmod u+x ./init/dependency.sh
RUN ./init/dependency.sh

# =======================================================================
# Install Python Libraries 
# =======================================================================
FROM spark-deps AS spark-python
# Install python dependencies
COPY ./infrastructure/spark/requirements.txt .
RUN pip3 install -r requirements.txt

# =======================================================================
# Set Environment Variables for Spark 
# =======================================================================
ENV PATH="${SPARK_HOME}/sbin:${SPARK_HOME}/bin:${PATH}"
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077
ENV PYSPARK_PYTHON=python3

# =======================================================================
# Set The sbin and bin to be Executable
# =======================================================================
RUN chmod u+x ./sbin/* && \
    chmod u+x ./bin/*

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

# =======================================================================
# Run init script
# =======================================================================
RUN chmod u+x ./init/init.sh
ENTRYPOINT [ "./init/init.sh" ]