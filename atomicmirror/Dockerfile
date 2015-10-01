FROM fedora:22

MAINTAINER Joshua Preston <jpreston@redhat.com>

# Setup our locations

ENV CONFDIR /etc/atomicmirror
ENV DATADIR /var/lib/atomicmirror
ENV LOGDIR  /var/log/atomicmirror

# Setup the repos we are going to enable for syncing

ENV OSTREE_ENABLE_REPOS fedora-atomic-22

# install needed packages

RUN dnf install -y rpm-ostree polipo; \
    dnf clean all

# create required directories

RUN mkdir -p ${CONFDIR} ${DATADIR} ${LOGDIR}

# install our run.sh script that does our magic

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

# install our repository configs

COPY repos ${CONFDIR}/repos

# make sure the volume is exported for retention purposes

VOLUME ${CONFDIR}
VOLUME ${DATADIR}
VOLUME ${LOGDIR}

# expose default SimpleHTTPServer port and set working dir

EXPOSE 8000

# make sure we're working out of the data directory

WORKDIR ${DATADIR}

# start web proxy and SimpleHTTPServer

CMD /usr/local/bin/run.sh
