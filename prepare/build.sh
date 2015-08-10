#!/bin/bash

# Generate our cloud-init images
type -a genisoimage >/dev/null 2>&1 && for A_HOST in atomic-host-*; do
	pushd "${A_HOST}"
	genisoimage -output ../${A_HOST}-cidata.iso -volid cidata -joliet -rock user-data meta-data
	popd
done

# Generate our index file
type -a markdown >/dev/null 2>&1 && {
  cat header.html
  markdown --html4tags index.md
  cat footer.html
} > index.html
