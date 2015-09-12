FROM fedora:22

MAINTAINER Joshua Preston <jpreston@redhat.com>

ENV OSTREE_ENABLE_REPOS fedora-atomic-22

# install needed packages

RUN dnf install -y rpm-ostree polipo; \
    dnf clean all

# create required directories

RUN mkdir -p /home/working /srv/rpm-ostree

# install our run.sh script that does our magic

COPY run.sh /home/working/run.sh
RUN chmod +x /home/working/run.sh

# install our repository configs

COPY repos /home/working/repos

# make sure the volume is exported for retention purposes

VOLUME /srv/rpm-ostree

# expose default SimpleHTTPServer port and set working dir

EXPOSE 8000
WORKDIR /home/working

# start web proxy and SimpleHTTPServer

CMD /home/working/run.sh ${OSTREE_ENABLE_REPOS}
