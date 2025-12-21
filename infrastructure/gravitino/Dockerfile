# Load ARG variables
ARG GRAVITINO_IMAGE_TAG="1.1.0"

# Build image from apache/gravitino base image
FROM apache/gravitino:${GRAVITINO_IMAGE_TAG} AS gravitino-base

RUN apt-get update

FROM gravitino-base AS gravitino

# =======================================================================
# Copy all initialization scripts
# =======================================================================
# Commmon initialization scripts
COPY ./infrastructure/common/ ./common/

# Gravitino initialization scripts
COPY ./infrastructure/gravitino/init/ ./init/

# =======================================================================
# Install Gravitino Dependencies
# =======================================================================
RUN chmod u+x ./init/dependency.sh
RUN ./init/dependency.sh

# =======================================================================
# Run Gravitino Initialization Script
# =======================================================================
RUN chmod u+x ./init/init.sh
ENTRYPOINT [ "./init/init.sh" ]