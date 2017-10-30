FROM alpine:3.6

ARG BUILD_DATE
ARG VERSION[=0.178]
ARG JVM_MAX[=16G]
ARG MAX_MEMORY[=50G]
ARG NODE_MEMORY[=1GB]
ARG HOSTNAME[=presto]
ARG HIVE_METASTORS_URI


LABEL \
    maintainer="lonly197@qq.com" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="lonly197/presto" \
    org.label-schema.url="https://github.com/lonly197" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.version=$VERSION \
    org.label-schema.vcs-url="https://github.com/lonly197/docker-presto"

ENV PRESTO_VERSION       ${VERSION}
ENV PRESTO_HOME          /usr/local/presto-server
ENV PRESTO_CONF_DIR      ${PRESTO_HOME}/etc
ENV PRESTO_NODE_DATA_DIR /presto
ENV PRESTO_LOG_DIR       /var/log/presto
ENV PRESTO_JVM_MAX_HEAP  ${JVM_MAX} 
ENV PRESTO_QUERY_MAX_MEMORY          ${MAX_MEMORY} 
ENV PRESTO_QUERY_MAX_MEMORY_PER_NODE ${NODE_MEMORY}
ENV PRESTO_PORT 8080
ENV PRESTO_DISCOVERY_URI  http://coordinator-1.vnet:${PRESTO_PORT} 

ENV JAVA_HOME   /usr/lib/jvm/default-jvm
ENV PATH        $PATH:${JAVA_HOME}/bin:${PRESTO_HOME}/bin

ENV HIVE_METASTORS_URI  ${HIVE_METASTORS_URI}

RUN set -x \
    && apk update \
    && apk --no-cache add \
        bash \
        less \
        openjdk8-jre \
        python \
        su-exec \
        tar \ 
        wget \
    && apk --no-cache add --virtual .builddeps \
        openjdk8 \
        zip \

    ## presto-server
    && wget -q -O - https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz \
        | tar -xvzf - -C /usr/local  \

    ## presto-client
    && wget -q -O /usr/local/bin/presto https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar \
    && chmod +x /usr/local/bin/presto \

    ## user/dir/permmsion
    && adduser -D  -g '' -s /sbin/nologin -u 1000 docker \
    && adduser -D  -g '' -s /sbin/nologin presto \
    && mkdir -p \
        ${PRESTO_CONF_DIR} \
        ${PRESTO_LOG_DIR} \
        ${PRESTO_NODE_DATA_DIR} \
    && chown -R presto:presto \
        ${PRESTO_HOME} \
        ${PRESTO_LOG_DIR} \
        ${PRESTO_NODE_DATA_DIR} \

    ## cleanup
    && rm -rf /tmp/nativelib \
    && apk del .builddeps 
    
COPY config/etc/*  ${PRESTO_CONF_DIR}/
COPY config/bin/*  /usr/local/bin/
COPY config/lib/*  /usr/local/lib/

VOLUME ["${PRESTO_LOG_DIR}", "${PRESTO_NODE_DATA_DIR}"]

WORKDIR ${PRESTO_HOME}

ENTRYPOINT ["entrypoint.sh"]