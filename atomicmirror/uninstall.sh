#!/bin/sh
chroot ${HOST} /usr/bin/systemctl disable /etc/systemd/system/atomicmirror_${NAME}.service
rm -f ${HOST}/etc/systemd/system/atomicmirror_${NAME}.service
