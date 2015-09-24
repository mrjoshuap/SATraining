# Deploy Atomic Hosts

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Agenda](#agenda)
- [Preferred Deployment Option: KVM Environment Setup](#preferred-deployment-option-kvm-environment-setup)
  - [Install the Atomic ```cloud-init``` images](#install-the-atomic-cloud-init-images)
  - [Install "gold" VM Image](#install-gold-vm-image)
  - [Install the VM images (adjust BRIDGE appropriately)](#install-the-vm-images-adjust-bridge-appropriately)
- [Deployment Option: VirtualBox Environment Setup](#deployment-option-virtualbox-environment-setup)
  - [Create VM Data Paths](#create-vm-data-paths)
  - [Install ISO images](#install-iso-images)
  - [Convert VM images](#convert-vm-images)
  - [Create Network](#create-network)
  - [Create VMs](#create-vms)
- [Verify the Atomic Hosts](#verify-the-atomic-hosts)
- [Explore the Environment](#explore-the-environment)

<!-- /MarkdownTOC -->

## Agenda

1. Create VM for `atomic-master`
1. Create 4 VMs for `atomic-hosts`
1. Verify Atomic Hosts
1. Explore the Environment

There are many ways to deploy an Atomic Host. In this lab, we provide guidance for KVM and VirtualBox.  We will be utilizing cloud images that are typically used with libvirt (KVM) and OpenStack.

Based on which image you downloaded, we need to set an environment variable of the filename without extension.

```bash
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

```bash
sudo cp atomic-master-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-01-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-02-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-03-cidata.iso /var/lib/libvirt/images/
sudo cp atomic-host-04-cidata.iso /var/lib/libvirt/images/
```

### Install "gold" VM Image

Make copy-on-write images, using the downloaded image as a "gold" master.

```bash
sudo cp ${A_IMAGE}.qcow2 /var/lib/libvirt/images/.
```

### Install the VM images (adjust BRIDGE appropriately)

```bash
BRIDGE=virbr0
LAST_OCTET=10
for VM in atomic-master atomic-host-01 atomic-host-02 atomic-host-03 atomic-host-04; do
  sudo test -f /var/lib/libvirt/images/${VM}-docker.qcow2 \
    && sudo rm -f /var/lib/libvirt/images/${VM}-docker.qcow2
  sudo chown qemu:qemu "/var/lib/libvirt/images/${VM}*"
  sudo qemu-img create -f qcow2 \
    -o backing_file="/var/lib/libvirt/images/${A_IMAGE}.qcow2" \
    "/var/lib/libvirt/images/${VM}.qcow2"
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

```bash
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

## Explore the Environment

What can you do?  What can't you do?  You may see a lot of "Command not found" messages...  We'll explain how to get around that with the tools container in a later lab.

Type the following commands.

```
man tcpdump

git

tcpdump

sosreport
```

Why wouldn't we include these commands in the Atomic image?

If you want to add something to Atomic Host, you must build a container.

*This concludes the Deploy Atomic Hosts lab.*

[NEXT LAB](2_configureStorage.md)
