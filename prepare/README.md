# Project Atomic Training

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Before You Arrive](#before-you-arrive)
  - [Notes, Comments and Pointers](#notes-comments-and-pointers)
  - [Downloads](#downloads)
  - [Download Required Softwares](#download-required-softwares)
    - [Grab the ```cloud-init``` images](#grab-the-cloud-init-images)
    - [Grab the Cloud Atomic image](#grab-the-cloud-atomic-image)
      - [Fedora Cloud Atomic (preferred)](#fedora-cloud-atomic-preferred)
      - [CentOS Cloud Atomic](#centos-cloud-atomic)
      - [Red Hat Enterprise Linux Atomic Host](#red-hat-enterprise-linux-atomic-host)
  - [References](#references)

<!-- /MarkdownTOC -->

# Before You Arrive

In order to make best use of lab time, please review the deployment options and ensure you have one of the following:

1. A working KVM environment (preferred)
1. A working Virtual Box environment

Before the training begins, please plan on creating the necessary Virtual Machines that will be used for this class as described in this document.  Minimal time will be allocated during the training to complete these steps.

### Notes, Comments and Pointers

* It is assumed that you will be utilizing Fedora Cloud Atomic
* Use sudo and appropriate permissions; insert standard security warnings here
* Correct IPs, hostnames, paths and locations to match your setup
* You will need to change the bridge device and/or adapter to match your setup

## Downloads

We are going to be working with the Fedora Cloud Atomic image, however, this training should work with little to no modification on CentOS Atomic and Red Hat Enterprise Linux Atomic Host.

1. [Fedora Atomic](https://getfedora.org/cloud/download/atomic.html) (preferred)
1. [CentOS Atomic](http://cloud.centos.org/centos/7/atomic/images/)
1. [Red Hat Enterprise Linux Atomic Host](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)

The ```cloud-init``` images provided are basic and are not intended for use in a real world environment.  Though not covered in this training, you should choose to [customize the ```cloud-init``` image](http://cloudinit.readthedocs.org/en/latest/topics/examples.html) for instance: adding your own SSH public keys, changing the default password and setting other options as necessary.

## Download Required Softwares

### Grab the ```cloud-init``` images

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

```
wget https://download.fedoraproject.org/pub/fedora/linux/releases/22/Cloud/x86_64/Images/Fedora-Cloud-Atomic-22-20150521.x86_64.qcow2
```

#### CentOS Cloud Atomic

```
wget http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7.1.2-GenericCloud.qcow2
```

#### Red Hat Enterprise Linux Atomic Host

You'll need an active subscription to download from [access.redhat.com](https://access.redhat.com/downloads/content/271/ver=/rhel---7/7.1.4/x86_64/product-downloads)

Now, wait until the class, you may want to run through some reference materials!

## References

1. [Project Atomic](http://www.projectatomic.io/)
1. [Docker](https://www.docker.io/)
1. [Kubernetes](http://kubernetes.io/)
1. [rpm-ostree](http://www.projectatomic.io/docs/os-updates/)
1. [systemd](http://www.freedesktop.org/wiki/Software/systemd/)
1. [cloud-init](https://cloudinit.readthedocs.org/en/latest/)
