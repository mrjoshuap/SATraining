# atomicmirror

<!-- MarkdownTOC -->

- Overview
- Atomic Installation
- Manual Installation

<!-- /MarkdownTOC -->

## Overview

The purpose of this container is to host a local atomic rpm-ostree mirror so
that internet access is not required.  Content is served via HTTP on port 8000.

The following repositories are configured by default:

* centos-atomic-7
* fedora-atomic-21
* fedora-atomic-22

## Atomic Installation

This docker image is configured to run on an Atomic host, and should be installed
with an `atomic install mrjoshuap/atomicmirror` command.  This will configure and
install the container.

## Manual Installation

You do not have to run this in an atomic host, but you'll need to configure it
correctly before having great success.

Pull the image

```
docker pull mrjoshuap/atomic-mirror
```

Run the container

```
docker run \
  -v /my/data/store:/var/lib/atomicmirror \
  -p 8000:8000 \
  --name atomicmirror mrjoshuap/atomicmirror
```
