FROM alpine:3.5
LABEL maintainer "vmizzle@gmail.com"

ENV DHCPD_VERSION=4.3.4-r2

RUN apk add --update bash dhcp=${DHCPD_VERSION} && \
	rm -rf /var/cache/apk

RUN mkdir -p /srv/dhcpd
WORKDIR /srv/dhcpd

EXPOSE 67/udp 67/tcp

COPY init.sh /init
RUN chmod 750 /init

ENTRYPOINT ["/init"]
