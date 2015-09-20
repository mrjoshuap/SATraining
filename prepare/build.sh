#!/bin/bash

# Generate our cloud-init images
type -a genisoimage >/dev/null 2>&1 && mkdir -p iso log && for A_HOST in atomic-*; do
	test -d ${A_HOST} && genisoimage \
    -output iso/${A_HOST}-cidata.iso \
    -volid cidata -joliet \
    -rock ${A_HOST}/user-data ${A_HOST}/meta-data > log/${A_HOST}-cidata.log 2>&1
done

# Generate our index file from the readme.md
type -a markdown >/dev/null 2>&1 && {
  cat header.html
  markdown --html4tags readme.md
  cat footer.html
} > index.html
