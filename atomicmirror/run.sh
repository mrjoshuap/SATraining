#!/bin/bash

{
  echo "--------------------------------------"
  env
  echo "--------------------------------------"

  if [ "${OSTREE_ENABLE_REPOS}x" = "x" ]; then
    echo "ERROR: No ostree repositories specified!"
    exit -1
  fi

  for OSTREE_REPO in ${OSTREE_ENABLE_REPOS}; do

    if [ ! -f "${CONFDIR}/repos/${OSTREE_REPO}.repo" ]; then
      echo "ERROR: No repository configuration found for [${OSTREE_REPO}]!"
      continue
    else
      echo "INFO: Mirroring [${OSTREE_REPO}]"
    fi

    unset OSTREE_GPG_VERIFY OSTREE_ORIGIN_URL OSTREE_ORIGIN_REF
    source "${CONFDIR}/repos/${OSTREE_REPO}.repo"

    if [[ ! -d "${DATADIR}/${NAME}/${OSTREE_REPO}" && ! -f "${DATADIR}/${NAME}/${OSTREE_REPO}/config" ]]; then
      mkdir -p "${DATADIR}/${NAME}/${OSTREE_REPO}"
      ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" init --mode=archive-z2
      ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" remote add --set=gpg-verify=${OSTREE_GPG_VERIFY} origin ${OSTREE_ORIGIN_URL}
    fi

    echo "Pulling [${OSTREE_REPO}]" && ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" pull origin ${OSTREE_ORIGIN_REF} \
    && echo "Checking [${OSTREE_REPO}]"&& ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" fsck \
    && ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" refs \
    && ostree --repo="${DATADIR}/${NAME}/${OSTREE_REPO}" summary -u \
    || echo "ERROR: Failed Mirroring ostree repository [${OSTREE_REPO}]"

  done

  echo -n "Starting polipo..." \
    && polipo \
      && echo "ok" \
      || echo "failed"
} | tee -a ${LOGDIR}/${NAME}.log

echo "Starting SimpleHTTPServer..." \
  && python -m SimpleHTTPServer | tee -a ${LOGDIR}/${NAME}_access.log
