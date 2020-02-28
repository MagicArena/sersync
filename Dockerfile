FROM alpine:latest

LABEL cn.magicarnea.description="Sersync Docker image based on alpine." \
      cn.magicarnea.vendor="MagicArena" \
      cn.magicarnea.maintainer="everoctivian@gmail.com" \
      cn.magicarnea.versionCode=1 \
      cn.magicarnea.versionName="1.0.0"

VOLUME /etc/sersync
VOLUME /var/log/sersync

# if you want use APK mirror then uncomment, modify the mirror address to which you favor
# RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://mirrors.aliyun.com|g' /etc/apk/repositories

ENV TZ=Asia/Shanghai
RUN set -ex && \
    apk add --no-cache tzdata rsync && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    rm -rf /tmp/* /var/cache/apk/*

COPY sersync2.5.4_64bit_binary_stable_final.tar.gz /tmp/

WORKDIR /tmp

RUN set -ex && \
    touch /var/log/sersync/rsync_fail_log.sh && \
    mkdir -p /etc/sersync && \
    mkdir -p /var/log/sersync && \
    tar -xzvf /tmp/sersync2.5.4_64bit_binary_stable_final.tar.gz && \
    cp -a /tmp/GNU-Linux-x86/sersync2 /usr/bin/ && \
    cp -a /tmp/GNU-Linux-x86/confxml.xml /etc/sersync/confxml.xml && \
    chmod +x /usr/bin/sersync2 && \
    rm -rf /tmp/GNU-Linux-x86 && \
    rm -f /tmp/sersync2.5.4_64bit_binary_stable_final.tar.gz

CMD ["-r"]

ENTRYPOINT /usr/bin/sersync2 -o /etc/sersync/confxml.xml
