#!/bin/bash

OSTREE_ENABLE_REPOS=$*

if [ "${OSTREE_ENABLE_REPOS}x" = "x" ]; then
  echo "ERROR: No ostree repositories specified!"
  exit -1
fi

for OSTREE_REPO in ${OSTREE_ENABLE_REPOS}; do

  if [ ! -f "/home/working/repos/${OSTREE_REPO}.repo" ]; then
    echo "ERROR: No repository configuration found for [${OSTREE_REPO}]!"
    continue
  else
    echo "INFO: Mirroring [${OSTREE_REPO}]"
  fi

  unset OSTREE_GPG_VERIFY OSTREE_ORIGIN_URL OSTREE_ORIGIN_REF
  source "/home/working/repos/${OSTREE_REPO}.repo"

  pushd /srv/rpm-ostree/

  if [ ! -d "/srv/rpm-ostree/${OSTREE_REPO}" ]; then
    mkdir -p "/srv/rpm-ostree/${OSTREE_REPO}"
    ostree --repo="/srv/rpm-ostree/${OSTREE_REPO}" init --mode=archive-z2
    ostree --repo="/srv/rpm-ostree/${OSTREE_REPO}" remote add --set=gpg-verify=${OSTREE_GPG_VERIFY} origin ${OSTREE_ORIGIN_URL}
  fi

  ostree --repo="/srv/rpm-ostree/${OSTREE_REPO}" pull origin ${OSTREE_ORIGIN_REF} \
  && ostree --repo="/srv/rpm-ostree/${OSTREE_REPO}" fsck \
  && ostree --repo="/srv/rpm-ostree/${OSTREE_REPO}" refs \
  && ostree --repo="/srv/rpm-ostree/${OSTREE_REPO}" summary -u \
  || echo "ERROR: Failed Mirroring ostree repository [${OSTREE_REPO}]"

done

echo -n "Starting polipo..." && polipo && echo "ok" || echo "failed"
echo -n "Starting SimpleHTTPServer..." && python -m SimpleHTTPServer && echo "ok" || echo "failed"

popd
