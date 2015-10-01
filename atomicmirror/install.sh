#!/bin/sh

# Make required directories on host
mkdir -p ${HOST}/${CONFDIR} ${HOST}/${DATADIR}/${NAME} ${HOST}/${LOGDIR}/${NAME}

# Copy repository information
cp -pR ${CONFDIR}/repos ${HOST}/${CONFDIR}

# Create container
chroot ${HOST} /usr/bin/docker create -p 8000 -v ${CONFDIR}:${CONFDIR}/${NAME}:Z -v ${LOGDIR}:${LOGDIR}/${NAME}:Z -v ${DATADIR}:${DATDIR}/${NAME}:Z --name ${NAME} ${IMAGE}

# Install systemd unit file for running container
sed -e "s/NAME/${NAME}/g" /etc/systemd/system/atomicmirror_template.service > ${HOST}/etc/systemd/system/atomicmirror_${NAME}.service

# Enabled systemd unit file
chroot ${HOST} /usr/bin/systemctl enable /etc/systemd/system/atomicmirror_${NAME}.service
