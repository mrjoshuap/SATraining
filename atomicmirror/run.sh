#!/bin/bash

echo "--------------------------------------" | tee ${LOGDIR}/${NAME}.log
env | tee ${LOGDIR}/${NAME}.log
echo "--------------------------------------" | tee ${LOGDIR}/${NAME}.log

if [ "${OSTREE_ENABLE_REPOS}x" = "x" ]; then
  echo "ERROR: No ostree repositories specified!" | tee ${LOGDIR}/${NAME}.log
  exit -1
fi

for OSTREE_REPO in ${OSTREE_ENABLE_REPOS}; do

  if [ ! -f "${CONFDIR}/repos/${OSTREE_REPO}.repo" ]; then
    echo "ERROR: No repository configuration found for [${OSTREE_REPO}]!" | tee ${LOGDIR}/${NAME}.log
    continue
  else
    echo "INFO: Mirroring [${OSTREE_REPO}]" | tee ${LOGDIR}/${NAME}.log
  fi

  unset OSTREE_GPG_VERIFY OSTREE_ORIGIN_URL OSTREE_ORIGIN_REF
  source "${CONFDIR}/repos/${OSTREE_REPO}.repo"

  if [[ ! -d "${DATADIR}/${NAME}/${OSTREE_REPO}" && ! -f "${DATADIR}/${NAME}/${OSTREE_REPO}/config" ]]; then
    mkdir -p "${DATADIR}/${NAME}/${OSTREE_REPO}"
    ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" init --mode=archive-z2 | tee ${LOGDIR}/${NAME}.log
    ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" remote add --set=gpg-verify=${OSTREE_GPG_VERIFY} origin ${OSTREE_ORIGIN_URL} | tee ${LOGDIR}/${NAME}.log
  fi

  ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" pull origin ${OSTREE_ORIGIN_REF} | tee ${LOGDIR}/${NAME}.log \
  && ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" fsck | tee ${LOGDIR}/${NAME}.log \
  && ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" refs | tee ${LOGDIR}/${NAME}.log \
  && ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" summary -u | tee ${LOGDIR}/${NAME}.log \
  || echo "ERROR: Failed Mirroring ostree repository [${OSTREE_REPO}]" | tee ${LOGDIR}/${NAME}.log

done

echo -n "Starting polipo..." | tee ${LOGDIR}/${NAME}.log \
  && polipo | tee ${LOGDIR}/${NAME}.log \
    && echo "ok" | tee ${LOGDIR}/${NAME}.log \
    || echo "failed" | tee ${LOGDIR}/${NAME}.log

echo "Starting SimpleHTTPServer..." | tee ${LOGDIR}/${NAME}.log \
  && python -m SimpleHTTPServer | tee ${LOGDIR}/${NAME}_access.log
