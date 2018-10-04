FROM       alpine:3.8
MAINTAINER Viacheslav Kalashnikov <xemuliam@gmail.com>
ARG        GLIBC_MIRROR=https://github.com/sgerrand/alpine-pkg-glibc
ARG        GLIBC_VERSION=2.28-r0
ENV        LANG=C.UTF-8
RUN        apk add --no-cache --virtual=.build-deps curl && \
           curl -Lo /etc/apk/keys/sgerrand.rsa.pub "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" && \
           curl -Lo /glibc.apk "${GLIBC_MIRROR}/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
           curl -Lo /glibc-bin.apk "${GLIBC_MIRROR}/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
           curl -Lo /glibc-i18n.apk "${GLIBC_MIRROR}/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk" && \
           apk add --no-cache --allow-untrusted \
             /glibc.apk \
             /glibc-bin.apk \
             /glibc-i18n.apk && \
           /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
           echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
           rm -rf /etc/apk/keys/sgerrand.rsa.pub \
             /glibc.apk \
             /glibc-bin.apk \
             /glibc-i18n.apk && \
           apk del glibc-i18n \
             .build-deps
