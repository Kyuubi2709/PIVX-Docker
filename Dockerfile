ARG UBUNTUVER=20.04
FROM ubuntu:${UBUNTUVER}
LABEL com.centurylinklabs.watchtower.enable="true"

RUN mkdir -p /root/.blocx
RUN apt-get update && apt-get install -y  tar wget curl pwgen jq
RUN wget -O /tmp/Blocx-2.0.0-ubuntu-daemon.tar.gz https://github.com/BLOCXTECH/BLOCX/releases/download/v2.0.0/Blocx-2.0.0-ubuntu-daemon.tar.gz && \
    tar -xvf /tmp/Blocx-2.0.0-ubuntu-daemon.tar.gz -C /usr/local/bin && \
    rm /tmp/Blocx-2.0.0-ubuntu-daemon.tar.gz
COPY node_initialize.sh /node_initialize.sh
COPY check-health.sh /check-health.sh
VOLUME /root/.blocx
RUN chmod 755 node_initialize.sh check-health.sh
EXPOSE 12972
HEALTHCHECK --start-period=5m --interval=2m --retries=5 --timeout=15s CMD ./check-health.sh
CMD ./node_initialize.sh