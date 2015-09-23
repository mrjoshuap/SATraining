# Deploy Atomic Hosts

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Set the appropriate image](#set-the-appropriate-image)
  - [Preferred Deployment Option: KVM Environment Setup](#preferred-deployment-option-kvm-environment-setup)
    - [Install the Atomic ```cloud-init``` images](#install-the-atomic-cloud-init-images)
    - [Create five copies of the image (one for each host)](#create-five-copies-of-the-image-one-for-each-host)
    - [Install the images (adjust BRIDGE appropriately)](#install-the-images-adjust-bridge-appropriately)
  - [Deployment Option: VirtualBox Environment Setup](#deployment-option-virtualbox-environment-setup)
    - [Create VM Data Paths](#create-vm-data-paths)
    - [Install ISO images](#install-iso-images)
    - [Convert VM images](#convert-vm-images)
    - [Create Network](#create-network)
    - [Create VMs](#create-vms)
  - [Verify the Atomic Hosts](#verify-the-atomic-hosts)
  - [*Deployment Option 1: Atomic Hosts on OpenStack**](#deployment-option-1-atomic-hosts-on-openstack)
  - [*Deployment Option 2: Atomic Hosts on KVM**](#deployment-option-2-atomic-hosts-on-kvm)
  - [*Update VMs**](#update-vms)
  - [Configure docker to use a private registry](#configure-docker-to-use-a-private-registry)
  - [Explore the environment](#explore-the-environment)
- [If you want to add something to Atomic Host, you must build a container](#if-you-want-to-add-something-to-atomic-host-you-must-build-a-container)
  - [NEXT LAB](#next-lab)

<!-- /MarkdownTOC -->


There are many ways to deploy an Atomic Host. In this lab, we provide guidance for OpenStack or local KVM.

## Set the appropriate image

Based on which image you downloaded, we need to set an environment variable of the filename without extension.

```
# For Fedora-Cloud (preferred)
A_IMAGE=Fedora-Cloud-Atomic-22-20150521.x86_64

# For CentOS 7 Atomic
A_IMAGE=CentOS-Atomic-Host-7.1.2-GenericCloud

# For RHEL 7 Atomic
A_IMAGE=rhel-atomic-cloud-7.1-12.x86_64

export A_IMAGE
```

## Preferred Deployment Option: KVM Environment Setup

### Install the Atomic ```cloud-init``` images

```
sudo cp atomic-master-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-01-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-02-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-03-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-04-cidata.iso /var/lib/libvirt/images/
```

### Create five copies of the image (one for each host)

```
sudo cp ${A_IMAGE}.qcow2 /var/lib/libvirt/images/atomic-master.qcow2
sudo cp ${A_IMAGE}.qcow2 /var/lib/libvirt/images/atomic-host-01.qcow2
sudo cp ${A_IMAGE}.qcow2 /var/lib/libvirt/images/atomic-host-02.qcow2
sudo cp ${A_IMAGE}.qcow2 /var/lib/libvirt/images/atomic-host-03.qcow2
sudo cp ${A_IMAGE}.qcow2 /var/lib/libvirt/images/atomic-host-04.qcow2
```

### Install the images (adjust BRIDGE appropriately)

```
BRIDGE=virbr0
LAST_OCTET=10
for VM in atomic-master atomic-host-01 atomic-host-02 atomic-host-03 atomic-host-04; do
  sudo test -f /var/lib/libvirt/images/${VM}-docker.qcow2 \
    && sudo rm -f /var/lib/libvirt/images/${VM}-docker.qcow2
  sudo chown qemu:qemu "/var/lib/libvirt/images/${VM}*"
  sudo virt-install --import --name "${VM}" \
    --os-variant fedora21 \
    --ram 1024 --vcpus 2 \
    --disk path=/var/lib/libvirt/images/${VM}.qcow2,format=qcow2,bus=virtio \
    --disk path=/var/lib/libvirt/images/${VM}-docker.qcow2,format=qcow2,bus=virtio,size=10 \
    --disk path=/var/lib/libvirt/images/${VM}-cidata.iso,device=cdrom \
    --network bridge=${BRIDGE} --force \
    --noautoconsole
  A_MAC=$(sudo virsh domiflist ${VM} | tail -n 2 | head -n 1 | awk '{print $5}')
  sudo virsh net-update default add ip-dhcp-host \
    "<host mac='${A_MAC}' name='${VM}' ip='192.168.122.${LAST_OCTET}' />" \
    --live --config
    LAST_OCTET=$((${LAST_OCTET}+1))
done
```

## Deployment Option: VirtualBox Environment Setup

### Create VM Data Paths

Create paths to separate host data

```
mkdir atomic-master atomic-host-{01,02,03,04}
```

### Install ISO images

Install the Atomic cloud-init ISO image

```
mv atomic-master-cidata.iso atomic-master/
mv atomic-host-01-cidata.iso atomic-host-01/
mv atomic-host-02-cidata.iso atomic-host-02/
mv atomic-host-03-cidata.iso atomic-host-03/
mv atomic-host-04-cidata.iso atomic-host-04/
```

### Convert VM images

Convert the qcow2 image to vdi for VirtualBox usages

```
qemu-img convert -O vdi \
  ${A_IMAGE}.qcow2 \
  ${A_IMAGE}.vdi
```

### Create Network

Create a NAT network and configure it

```
VBoxManage natnetwork add --netname "vboxnat0" --network 192.168.122.0/24 --enable --dhcp on
```

### Create VMs

Create five VMs and attach the appropriate images (adjust BRIDGE appropriately)

```
BRIDGE=en0
for VM in atomic-master atomic-host-01 atomic-host-02 atomic-host-03 atomic-host-04; do
  # Copy the cloud image to a unique disk image for each host
  cp ${A_IMAGE}.vdi "${VM}/${VM}.vdi"
  # Reset the UUID for the disk image so it doesn't clash
  VBoxManage internalcommands sethduuid "${VM}/${VM}.vdi"
  # Create the VM
  VBoxManage createvm --name "${VM}" \
    --ostype "Fedora_64" \
    --register
  # Add our storage controller
  VBoxManage storagectl "${VM}" \
    --name "SCSI Controller" \
    --add scsi --controller LSILogic
  # Attach our disk image
  VBoxManage storageattach "${VM}" \
    --storagectl "SCSI Controller" \
    --port 0 --device 0 --type hdd \
    --medium "${VM}/${VM}.vdi"
  # Add an IDE controller for the CDROM
  VBoxManage storagectl "${VM}" \
    --name "IDE Controller" \
    --add ide
  # Attach our ISO image to the CDROM
  VBoxManage storageattach "${VM}" \
    --storagectl "IDE Controller" \
    --port 0 --device 0 --type dvddrive \
    --medium "${VM}/${VM}-cidata.iso"
  # Set various options, like memory, boot order, and network type
  VBoxManage modifyvm "${VM}" --ioapic on
  VBoxManage modifyvm "${VM}" --boot1 dvd --boot2 disk --boot3 none --boot4 none
  VBoxManage modifyvm "${VM}" --memory 1024 --vram 128
  VBoxManage modifyvm "${VM}" --nic1 natnetwork --nat-network1 vboxnat0 --bridgeadapter1 ${BRIDGE}
  # Create a storage disk for our docker images
  test -f "${VM}/${VM}-docker-images.vdi" || VBoxManage createhd \
    --filename "${VM}/${VM}-docker-images.vdi" \
    --size 10240
  # Attach our disk for docker images
  VBoxManage storageattach "${VM}" \
    --storagectl "SCSI Controller" \
    --port 1 --device 0 --type hdd \
    --medium "${VM}/${VM}-docker-images.vdi"
done
```

## Verify the Atomic Hosts

Now you should have five atomic hosts:

* ```atomic-master```
* ```atomic-host-01```
* ```atomic-host-02```
* ```atomic-host-03```
* ```atomic-host-04```

Power them on, validate the host names and make sure you can login using the following credentials:

For Fedora Atomic (preferred):

* Username: ```fedora```
* Password: ```atomic```

For CentOS Atomic:

* Username: ```centos```
* Password: ```atomic```

For RHEL Atomic:

* Username: ```cloud-user```
* Password: ```atomic```

You might also want to record IPs to make your life easier.



##**Deployment Option 1: Atomic Hosts on OpenStack**
You may use an OpenStack service, which needs to have a keypair and a security group already configured.

1. Navigate to Instances
1. Click "Launch Instances"
1 Complete dialog
  1. Details tab
    * Instance name: arbitrary name. Note the UUID of the image will be appended to the instance name. You may want to use your name in the image so you can easily find it.
    * Flavor: *m1.medium*
    * Instance count: *3*
    * Instance Boot Source: *Boot from image*
      * Image name: *[atomic_image]*
  1. Access & Security tab
    * Select your keypair that was uploaded during OpenStack account setup
    * Security Groups: *Default*
1. Click "Launch"

Three VMs will be created. Once the Power State is *Running*, you may SSH into the VMs using your matching SSH key. 

* Note: Each instance requires a floating IP address in addition to the private OpenStack `172.x.x.x` address. Your OpenStack tenant may automatically assign a floating IP address. If not, you may need to assign it manually. If no floating IP addresses are available, create them.
  1. Navigate to Access & Security
  1. Click "Floating IPs" tab
  1. Click "Allocate IPs to project"
  1. Assign floating IP addresses to each VM instance
* SSH into the VMs with user `cloud-user` and the instance floating IP address. This address will probably be in the `10.3.xx.xx` range.

```
ssh -i <private SSH key> cloud-user@10.3.xx.xxx
```


##**Deployment Option 2: Atomic Hosts on KVM**

* Grab and extract the Atomic and metadata images from our internal repository.  Use sudo and appropriate permissions.

```
wget [metadata ISO image]
cp atomic0-cidata.iso /var/lib/libvirt/images/.
wget [atomic QCOW2 image]
cp rhel-atomic-host-7.qcow2.gz /var/lib/libvirt/images/.; cd /var/lib/libvirt/images
gunzip rhel-atomic-host-7.qcow2.gz
```

* Make 3 copy-on-write images, using the downloaded image as a "gold" master.

```bash
for i in $(seq 3); do qemu-img create -f qcow2 -o backing_file=rhel-atomic-host-7.qcow2 rhel-atomic-host-7-${i}.qcow2 ; done
```

* Use the following commands to install the images. Note: You will need to change the bridge (br0) to match your setup, or at least confirm it matches what you have. You may also want to change the os-variant parameter to match your host (e.g. sample values include "rhel7.0", "fedora21",  or "centos7.0").

* For Fedora or CentOS atomic hosts, we need to create cloud init data i.e. atomic0-cidata.iso in below commands. Refer https://www.technovelty.org//linux/running-cloud-images-locally.html

```
virt-install --import --name atomic-ga-1 --os-variant=rhel7.0 --ram 1024 --vcpus 2 --disk path=/var/lib/libvirt/images/rhel-atomic-host-7-1.qcow2,format=qcow2,bus=virtio --disk path=/var/lib/libvirt/images/atomic0-cidata.iso,device=cdrom,readonly=on --network bridge=br0

virt-install --import --name atomic-ga-2 --os-variant=rhel7.0 --ram 1024 --vcpus 2 --disk path=/var/lib/libvirt/images/rhel-atomic-host-7-2.qcow2,format=qcow2,bus=virtio --disk path=/var/lib/libvirt/images/atomic0-cidata.iso,device=cdrom,readonly=on --network bridge=br0

virt-install --import --name atomic-ga-3 --os-variant=rhel7.0 --ram 1024 --vcpus 2 --disk path=/var/lib/libvirt/images/rhel-atomic-host-7-3.qcow2,format=qcow2,bus=virtio --disk path=/var/lib/libvirt/images/atomic0-cidata.iso,device=cdrom,readonly=on --network bridge=br0
```

##**Update VMs**

**NOTE:** We will be working on _all three (3)_ VMs. You will probably want to have three terminal windows or tabs open.

* Confirm you can log in to the hosts:

    Username: cloud-user
    Password: atomic (KVM only)

* Enter sudo shell:

```
sudo -i
```


* Update all of the Atomic Hosts. The following commands will subscribe you to receive updates and allow you to upgrade your Atomic Host.  

**NOTE:** Depending on the version of Atomic that you initially installed, some of the sample output below may differ from what you see.

**RHEL Atomic Host**
```
# atomic host status
  TIMESTAMP (UTC)         VERSION     ID             OSNAME               REFSPEC                                                 
* 2015-02-17 22:30:38     7.1.244     27baa6dee2     rhel-atomic-host     rhel-atomic-host:rhel-atomic-host/7/x86_64/standard     

# subscription-manager register --serverurl=[stage] --baseurl=[stage] --username=[account_user] --password=[account_pass] --auto-attach
```

**NOTE:** The below output is an example.  That is what a customer will see once there is a tree update.  What you will see in the lab is that there is "No upgrade available", this is expected.

**Fedora Atomic Host**
```
# atomic status
  TIMESTAMP (UTC)         ID             OSNAME            REFSPEC
* 2014-12-03 01:30:09     ba7ee9475c     fedora-atomic     fedora-atomic:fedora-atomic/f21/x86_64/docker-host
```

**NOTE:** The below output is an example.  That is what a customer will see once there is a tree update.  What you will see in the lab is that there is "No upgrade Available", this is expected.

```
# atomic host upgrade
Updating from: rhel-atomic-host-ostree:rhel-atomic-host/7/x86_64/standard

53 metadata, 321 content objects fetched; 81938 KiB transferred in 71 seconds
Copying /etc changes: 26 modified, 4 removed, 57 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Changed:
  libgudev1-208-99.atomic.0.el7.x86_64
  libsmbclient-4.1.12-21.el7_1.x86_64
  libwbclient-4.1.12-21.el7_1.x86_64
  python-six-1.3.0-4.el7.noarch
  redhat-release-atomic-host-7.1-20150219.0.atomic.el7.1.x86_64
  samba-common-4.1.12-21.el7_1.x86_64
  samba-libs-4.1.12-21.el7_1.x86_64
  shadow-utils-2:4.1.5.1-18.el7.x86_64
  subscription-manager-1.13.22-1.el7.x86_64
  subscription-manager-plugin-container-1.13.22-1.el7.x86_64
  subscription-manager-plugin-ostree-1.13.22-1.el7.x86_64
  systemd-208-99.atomic.0.el7.x86_64
  systemd-libs-208-99.atomic.0.el7.x86_64
  systemd-sysv-208-99.atomic.0.el7.x86_64
Upgrade prepared for next boot; run "systemctl reboot" to start a reboot
```

* Check the atomic tree version. The asterisk indicates the currently running tree. The tree displayed first in the list is the version that will be booted into. In the output below, if the system is rebooted, it will boot into the new 7.1.0 tree.

```
# atomic host status
  TIMESTAMP (UTC)         VERSION     ID             OSNAME               REFSPEC                                                        
  2015-02-19 20:26:26     7.1.0       5799825b36     rhel-atomic-host     rhel-atomic-host-ostree:rhel-atomic-host/7/x86_64/standard     
* 2015-02-17 22:30:38     7.1.244     27baa6dee2     rhel-atomic-host     rhel-atomic-host-ostree:rhel-atomic-host/7/x86_64/standard
```

* Reboot the VMs to switch to the updated tree.

```
# systemctl reboot
```

* After the VMs have rebooted, SSH into each and enter the sudo shell:

```
# sudo -i
```

* Check your version with the atomic command. The `*` pointer should now be on the new tree.

```
# atomic host status
  TIMESTAMP (UTC)         VERSION     ID             OSNAME               REFSPEC                                                        
* 2015-02-19 20:26:26     7.1.0       5799825b36     rhel-atomic-host     rhel-atomic-host-ostree:rhel-atomic-host/7/x86_64/standard     
  2015-02-17 22:30:38     7.1.244     27baa6dee2     rhel-atomic-host     rhel-atomic-host-ostree:rhel-atomic-host/7/x86_64/standard     

```

## Configure docker to use a private registry
Integrating a private registry is an important use case for customers. For this lab, we add a private registry to pull and search images.

* Edit the `/etc/sysconfig/docker` file and restart docker. You will need the following line in the file.

```
ADD_REGISTRY='--add-registry [PRIVATE_REGISTRY]'
```

**NOTE:** If the private registry is not configured with a CA-signed SSL certificate `docker pull ...` will fail with a message about an insecure registry. In that case, add the following line to `/etc/sysconfig/docker`:

```
INSECURE_REGISTRY='--insecure-registry [PRIVATE_REGISTRY]'
```

* `/etc/sysconfig/docker` includes example ADD_REGISTRY and INSECURE_REGISTRY lines.  Uncomment them and append the [PRIVATE_REGISTRY] FQDN.  For example:

```
ADD_REGISTRY='--add-registry my.private.registry.fqdn'
INSECURE_REGISTRY='--insecure-registry my.private.registry.fqdn'
```

* Restart docker

```
systemctl restart docker
```

## Explore the environment

What can you do?  What can't you do?  You may see a lot of "Command not found" messages...  We'll explain how to get around that with the rhel-tools container in a later lab. Type the following commands.  

```
man tcpdump

git

tcpdump

sosreport
```
Why wouldn't we include these commands in the Atomic image?

# If you want to add something to Atomic Host, you must build a container

Let's try:

```
atomic install rhel7/rhel-tools
```

This will install the rhel-tools container, which can be used as the administrator's shell.

Now let's try:

```
atomic run rhel7/rhel-tools man tcpdump
atomic run rhel7/rhel-tools tcpdump
```

You can also go into the rhel-tools container and explore its contents.

```
atomic run rhel7/rhel-tools /bin/sh
```

You might even want to create a shell script like the following on the Atomic Host as a helper script:

```
vi /usr/local/sbin/man
#!/bin/sh
atomic run rhel7/rhel-tools man $@

chmod +x /usr/local/sbin/man
```

This script makes using man pages transparent to the user (even though man pages are not installed on the Atomic Host, only in the rhel-tools container).
It could also be done with a bash alias.

```
man tcpdump
```

rhel-tools is a Super Privileged Container, which will be covered in the next presentation and lab.

This concludes the deploying Atomic lab.

## [NEXT LAB](atomicDockerLVM.md)
