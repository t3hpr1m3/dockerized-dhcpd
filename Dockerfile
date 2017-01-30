FROM alpine:3.5
LABEL maintainer "vmizzle@gmail.com"

ENV DHCPD_VERSION=4.3.4-r2

RUN apk add --update bash dhcp=${DHCPD_VERSION} && \
	rm -rf /var/cache/apk

RUN mkdir -p /srv/dhcpd/var

EXPOSE 67/udp 67/tcp

ENTRYPOINT ["/usr/sbin/dhcpd", \
			"-cf", "/srv/dhcpd/etc/dhcpd.conf", \
			"-lf", "/srv/dhcpd/var/dhcpd.leases", \
			"-pf", "/srv/dhcpd/var/dhcpd.pid", \
			"-user", "nobody",
			"-d",
			"-f"]
