#!/bin/bash

if [ "${OSTREE_ENABLE_REPOS}x" = "x" ]; then
  echo "ERROR: No ostree repositories specified!" | tee ${LOGDIR}/atomicmirror.log
  exit -1
fi

for OSTREE_REPO in ${OSTREE_ENABLE_REPOS}; do

  if [ ! -f "${CONFDIR}/repos/${OSTREE_REPO}.repo" ]; then
    echo "ERROR: No repository configuration found for [${OSTREE_REPO}]!" | tee ${LOGDIR}/atomicmirror.log
    continue
  else
    echo "INFO: Mirroring [${OSTREE_REPO}]" | tee ${LOGDIR}/atomicmirror.log
  fi

  unset OSTREE_GPG_VERIFY OSTREE_ORIGIN_URL OSTREE_ORIGIN_REF
  source "${CONFDIR}/repos/${OSTREE_REPO}.repo"

  if [[ ! -d "${DATADIR}/${OSTREE_REPO}" && ! -f "${DATADIR}/${OSTREE_REPO}/config" ]]; then
    mkdir -p "${DATADIR}/${OSTREE_REPO}"
    ostree --repo="${DATADIR}/${OSTREE_REPO}" init --mode=archive-z2 | tee ${LOGDIR}/atomicmirror.log
    ostree --repo="${DATADIR}/${OSTREE_REPO}" remote add --set=gpg-verify=${OSTREE_GPG_VERIFY} origin ${OSTREE_ORIGIN_URL} | tee ${LOGDIR}/atomicmirror.log
  fi

  ostree --repo="${DATADIR}/${OSTREE_REPO}" pull origin ${OSTREE_ORIGIN_REF} | tee ${LOGDIR}/atomicmirror.log \
  && ostree --repo="${DATADIR}/${OSTREE_REPO}" fsck | tee ${LOGDIR}/atomicmirror.log \
  && ostree --repo="${DATADIR}/${OSTREE_REPO}" refs | tee ${LOGDIR}/atomicmirror.log \
  && ostree --repo="${DATADIR}/${OSTREE_REPO}" summary -u | tee ${LOGDIR}/atomicmirror.log \
  || echo "ERROR: Failed Mirroring ostree repository [${OSTREE_REPO}]" | tee ${LOGDIR}/atomicmirror.log

done

echo -n "Starting polipo..." | tee ${LOGDIR}/atomicmirror.log \
  && polipo | tee ${LOGDIR}/atomicmirror.log \
    && echo "ok" | tee ${LOGDIR}/atomicmirror.log \
    || echo "failed" | tee ${LOGDIR}/atomicmirror.log

echo "Starting SimpleHTTPServer..." | tee ${LOGDIR}/atomicmirror.log \
  && python -m SimpleHTTPServer
