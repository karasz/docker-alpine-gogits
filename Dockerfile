FROM alpine:3.2

# Install system utils & Gogs runtime dependencies
ADD https://github.com/tianon/gosu/releases/download/1.6/gosu-amd64 /usr/sbin/gosu
RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/main" | tee -a /etc/apk/repositories \
 && echo "@community http://dl-4.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade \
 && apk -U --no-progress add ca-certificates bash git linux-pam s6@edge curl openssh socat \
 && chmod +x /usr/sbin/gosu \
 && rm -rf /var/cache/apk/*

ENV GOGS_CUSTOM /data/gogs

RUN mkdir -p /app/gogs/ && git clone https://github.com/gogits/gogs.git /app/gogs/
ADD http://dl.suckless.org/tools/ii-1.7.tar.gz /tmp/ii-1.7.tar.gz
WORKDIR /app/gogs/
ADD docker/compile.sh /tmp/compile.sh
RUN /tmp/compile.sh
RUN mkdir -p /data/ii
ADD docker/ii/iii.conf /data/ii/iii.conf
ADD docker/ii/iii /data/ii/iii

# Configure Docker Container
EXPOSE 22 3000

ENTRYPOINT ["docker/start.sh"]
CMD ["/usr/bin/s6-svscan", "/app/gogs/docker/s6/"]

