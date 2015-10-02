#!/bin/sh

PATH="/bin:/sbin"

if [ ! -f ${HOST}/etc/os-release -o ! -d ${HOST}/var/run ]; then
    echo "atomicmirror: host file system is not mounted at /host" >&2
    exit -1
fi

# Make required directories on host
mkdir -p ${HOST}/${CONFDIR}/${NAME} ${HOST}/${DATADIR}/${NAME} ${HOST}/${LOGDIR}/${NAME}

# Copy repository information
cp -pR ${CONFDIR}/repos ${HOST}/${CONFDIR}/${NAME}

# Create container
chroot ${HOST} /usr/bin/docker create -p 8000 -v ${CONFDIR}/${NAME}:${CONFDIR}:Z -v ${LOGDIR}/${NAME}:${LOGDIR}:Z -v ${DATADIR}/${NAME}:${DATDIR}:Z --name ${NAME} ${IMAGE}

# Install systemd unit file for running container
sed -e "s/NAME/${NAME}/g" /etc/systemd/system/atomicmirror_template.service > ${HOST}/etc/systemd/system/atomicmirror_${NAME}.service

# Enabled systemd unit file
chroot ${HOST} /usr/bin/systemctl enable /etc/systemd/system/atomicmirror_${NAME}.service
