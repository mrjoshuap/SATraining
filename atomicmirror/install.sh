#!/bin/sh

# Make Data Dirs
mkdir -p ${HOST}/${CONFDIR} ${HOST}/${DATADIR} ${HOST}/${LOGDIR}

# Copy repository information
if [ ! -d "${HOST}/${CONFDIR}/repos" ]; then
  cp -pR ${CONFDIR}/repos ${HOST}/${CONFDIR}
fi

# Create Container
chroot ${HOST} /usr/bin/docker create -v /var/log/${NAME}:/var/log/atomicmirror:Z -v /var/lib/atomicmirror:/var/lib/atomicmirror:Z --name atomicmirror ${IMAGE}

# Install systemd unit file for running container
cp /etc/systemd/system/atomicmirror.service ${HOST}/etc/systemd/system/atomicmirror.service

# Enabled systemd unit file
chroot ${HOST} /usr/bin/systemctl enable /etc/systemd/system/atomicmirror.service
