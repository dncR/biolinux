ARG DOCKER_IMAGE
ARG ARCH

FROM ${DOCKER_IMAGE}

# Define BUILD args.
ARG LANG

# Import values of ARGs from ENVIRONMENT
ENV LANG=${LANG}
ENV ARCH=${ARCH}

COPY scripts /tmp/scripts
RUN chmod -R 755 /tmp/scripts
RUN /tmp/scripts/install.sh

# RStudio server runs on port 8787 by default.
EXPOSE 8787

CMD ["/init"]
