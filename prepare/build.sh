#!/bin/bash

# Generate our cloud-init images
type -a genisoimage >/dev/null 2>&1 && mkdir -p iso && for A_HOST in atomic-host-*; do
	genisoimage -output iso/${A_HOST}-cidata.iso -volid cidata -joliet -rock ${A_HOST}/user-data ${A_HOST}/meta-data > ${A_HOST}-cidata.log 2>&1
done

# Generate our index file
type -a markdown >/dev/null 2>&1 && {
  cat header.html
  markdown --html4tags index.md
  cat footer.html
} > index.html
