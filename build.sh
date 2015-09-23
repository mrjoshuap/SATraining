#!/bin/bash

# Generate our cloud-init images
type -a genisoimage >/dev/null 2>&1 && mkdir -p prepare/iso prepare/log && for A_HOST in atomic-*; do
	test -d ${A_HOST} && genisoimage \
    -output prepare/iso/${A_HOST}-cidata.iso \
    -volid cidata -joliet \
    -rock prepare/${A_HOST}/user-data prepare/${A_HOST}/meta-data > prepare/log/${A_HOST}-cidata.log 2>&1
done

# Generate our index file from the readme.md
type -a flavor >/dev/null 2>&1 && flavor prepare/README.md > prepare/index.html

