#!/bin/bash

for A_HOST in atomic-host-*; do
	pushd "${A_HOST}"
	genisoimage -output ../${A_HOST}-cidata.iso -volid cidata -joliet -rock user-data meta-data
	popd
done
