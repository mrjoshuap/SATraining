# Project Atomic Training

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Overview](#overview)
- [Before You Arrive](#before-you-arrive)
  - [Notes, Comments and Pointers](#notes-comments-and-pointers)
- [Downloads](#downloads)
  - [Grab the ```cloud-init``` images](#grab-the-cloud-init-images)
  - [Grab the Cloud Atomic image](#grab-the-cloud-atomic-image)
    - [Fedora Cloud Atomic (preferred)](#fedora-cloud-atomic-preferred)
    - [CentOS Cloud Atomic](#centos-cloud-atomic)
    - [Red Hat Enterprise Linux Atomic Host](#red-hat-enterprise-linux-atomic-host)

<!-- /MarkdownTOC -->
# Overview

_Please be advised that this training may require Internet access for things such as downloading updates and Docker images._

The purpose of this training to to quickly demonstrate an application-centric IT architecture by providing an end-to-end solution for deploying containerized applications quickly and reliably, with atomic update and rollback for application and host alike.

We're going to be building 5 systems, one master and four hosts.  These directions will produce the following systems:

| hostname       | ip             | roles                                              |
|----------------|----------------|----------------------------------------------------|
| atomic-master  | 192.168.122.10 | cluster master, docker registry, ostree repository |
| atomic-host-01 | 192.168.122.11 | atomic container host                              |
| atomic-host-02 | 192.168.122.12 | atomic container host                              |
| atomic-host-03 | 192.168.122.13 | atomic container host                              |
| atomic-host-04 | 192.168.122.14 | atomic container host                              |

![Infrastructure Overview](infrastructure-diagram.png "Infrastructure Overview")

# Before You Arrive

In order to make best use of lab time, please review the deployment options and ensure you have one of the following:

1. A working KVM environment (preferred)
1. A working Virtual Box environment

Minimal time will be allocated during the training to get functional lab environments.

## Notes, Comments and Pointers

* It is assumed that you will be utilizing Fedora Cloud Atomic
* Use sudo and appropriate permissions; insert standard security warnings here
* Correct IPs, hostnames, paths and locations to match your setup
* You will need to change the bridge device and/or adapter to match your setup

# Downloads

We are going to be working with the Fedora Cloud Atomic image, however, this training should work with little to no modification on CentOS Atomic and Red Hat Enterprise Linux Atomic Host.

1. [Fedora Atomic](https://getfedora.org/cloud/download/atomic.html) (preferred)
1. [CentOS Atomic](http://cloud.centos.org/centos/7/atomic/images/)
1. [Red Hat Enterprise Linux Atomic Host](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)

The ```cloud-init``` images provided are basic and are not intended for use in a real world environment.  Though not covered in this training, you should choose to [customize the ```cloud-init``` image](http://cloudinit.readthedocs.org/en/latest/topics/examples.html) for instance: adding your own SSH public keys, changing the default password and setting other options as necessary.

### Grab the ```cloud-init``` images

* [atomic-master-cidata.iso](https://people.redhat.com/jpreston/atomic-training/atomic-master-cidata.iso)
* [atomic-host-01-cidata.iso](https://people.redhat.com/jpreston/atomic-training/atomic-host-01-cidata.iso)
* [atomic-host-02-cidata.iso](https://people.redhat.com/jpreston/atomic-training/atomic-host-02-cidata.iso)
* [atomic-host-03-cidata.iso](https://people.redhat.com/jpreston/atomic-training/atomic-host-03-cidata.iso)
* [atomic-host-04-cidata.iso](https://people.redhat.com/jpreston/atomic-training/atomic-host-04-cidata.iso)

Or, you can run:
```
wget https://people.redhat.com/jpreston/atomic-training/atomic-master-cidata.iso
wget https://people.redhat.com/jpreston/atomic-training/atomic-host-01-cidata.iso
wget https://people.redhat.com/jpreston/atomic-training/atomic-host-02-cidata.iso
wget https://people.redhat.com/jpreston/atomic-training/atomic-host-03-cidata.iso
wget https://people.redhat.com/jpreston/atomic-training/atomic-host-04-cidata.iso
```

### Grab the Cloud Atomic image

We want to download the appropriate cloud image.

#### Fedora Cloud Atomic (preferred)

[Fedora Atomic Host](https://download.fedoraproject.org/pub/fedora/linux/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Atomic-22-20150521.x86_64.qcow2)

Or, you can run:

```
wget https://download.fedoraproject.org/pub/fedora/linux/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Atomic-22-20150521.x86_64.qcow2
```

#### CentOS Cloud Atomic

[CentOS Atomic Host](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7.1.2-GenericCloud.qcow2)

Or, you can run:

```
wget http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7.1.2-GenericCloud.qcow2
```

#### Red Hat Enterprise Linux Atomic Host

You'll need an active subscription to download from [access.redhat.com](https://access.redhat.com/downloads/content/271/ver=/rhel---7/7.1.4/x86_64/product-downloads)

Now, wait until the class, you may want to run through some reference materials!
