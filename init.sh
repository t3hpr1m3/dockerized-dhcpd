#!/bin/sh

DHCPD_ROOT="/srv/dhcpd"
DHCPD_GROUP="dhcpd"
DHCPD_USER="dhcpd"

set -e

# Check ownership of the root dhcpd directory
gid=$(stat -c%g "${DHCPD_ROOT}")
uid=$(stat -c%u "${DHCPD_ROOT}")

# Get the existing uid/gid
gid_actual=$(id -g ${DHCPD_GROUP} 2>/dev/null || true)
uid_actual=$(id -u ${DHCPD_USER} 2>/dev/null || true)

[ -z $gid_actual ] && gid_actual=-1;
[ -z $uid_actual ] && uid_actual=-1;

if [ $gid -ne $gid_actual ] || [ $uid -ne $uid_actual ]; then
	if [ $uid_actual -gt -1 ]; then
		deluser ${DHCPD_USER}
	fi
	addgroup -S -g $gid ${DHCPD_GROUP}
	adduser -S -s /sbin/nologin -h /dev/null -H -g dhcpd -u $uid -G ${DHCPD_GROUP} -D ${DHCPD_USER}

	[ $gid_actual -gt -1 ] && find / -group $gid_actual -exec chown ${DHCPD_GROUP} {} \;
	[ $uid_actual -gt -1 ] && find / -user $uid_actual -exec chown ${DHCPD_USER} {} \;
fi

termhandler() {
	kill -TERM "$pid"
	wait $pid
	rc=$?
	if [ $rc -eq 143 ]; then
		exit 0
	else
		exit $rc
	fi
}

trap termhandler SIGTERM SIGINT

/usr/sbin/dhcpd \
	-cf ${DHCPD_ROOT}/etc/dhcpd.conf \
	-lf ${DHCPD_ROOT}/var/dhcpd.leases \
	-pf ${DHCPD_ROOT}/var/dhcpd.pid \
	-user ${DHCPD_USER} \
	-d -f "$@" &
pid="${!}"

set +e

wait $pid
