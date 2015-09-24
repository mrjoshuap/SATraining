# Configure Storage

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Agenda](#agenda)
  - [Begin](#begin)
- [Inspect the System](#inspect-the-system)
  - [Physical Volumes](#physical-volumes)
  - [Volume Groups](#volume-groups)
  - [Logical Volumes](#logical-volumes)
  - [Inspect Docker Information](#inspect-docker-information)
- [Configure Docker Storage](#configure-docker-storage)
  - [Stop Docker](#stop-docker)
  - [Remove Default Storage](#remove-default-storage)
  - [Configure Docker Storage Setup](#configure-docker-storage-setup)
  - [Run Docker Storage Setup](#run-docker-storage-setup)
  - [Start Docker](#start-docker)
- [Reinspect the System](#reinspect-the-system)
  - [Physical Volumes](#physical-volumes-1)
  - [Volume Groups](#volume-groups-1)
  - [Logical Volumes](#logical-volumes-1)
  - [Reinspect Docker Information](#reinspect-docker-information)
- [Download Docker Image](#download-docker-image)
- [Bind Mounts](#bind-mounts)

<!-- /MarkdownTOC -->

## Agenda

1. Inspect and understand LVM setup
1. Configure docker storage
1. Inspect the updated LVM setup
1. Download images, write inside the container
1. Use bind mounts, write to bind mount

### Begin

_NOTE: We will be working only on the `atomic-master`._

* Login to the `atomic-master`

# Inspect the System

Take note of the automatic storage configuration for Docker by looking at the physical volumes, volume groups and logical volumes. An Atomic Host comes optimized out of the box to take advantage of LVM thinpool storage, instead of the loopback used with Docker by default.

_First, you're going to need to have superuser access, so be sure to use `sudo` appropriately._

## Physical Volumes
```
# sudo pvs
  PV         VG       Fmt  Attr PSize PFree
  /dev/vda2  atomicos lvm2 a--  5.70g 52.00m
```

## Volume Groups
```
# sudo vgs
  VG       #PV #LV #SN Attr   VSize VFree
  atomicos   1   2   0 wz--n- 5.70g 52.00m
```

## Logical Volumes
```
# sudo lvs
  LV          VG       Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  docker-pool atomicos twi-aotz-- 2.71g             0.41   0.59
  root        atomicos -wi-ao---- 2.93g
```

## Inspect Docker Information

Now see how that corresponds to the Docker image and container storage:

```
# sudo docker info
Containers: 0
Images: 0
Storage Driver: devicemapper
 Pool Name: atomicos-docker--pool
 Pool Blocksize: 65.54 kB
 Backing Filesystem: xfs
 Data file:
 Metadata file:
 Data Space Used: 11.8 MB
 Data Space Total: 2.907 GB
 Data Space Available: 2.895 GB
 Metadata Space Used: 49.15 kB
 Metadata Space Total: 8.389 MB
 Metadata Space Available: 8.339 MB
 Udev Sync Supported: true
 Library Version: 1.02.93 (2015-01-30)
Execution Driver: native-0.2
Kernel Version: 4.0.4-301.fc22.x86_64
Operating System: Fedora 22 (Twenty Two)
CPUs: 2
Total Memory: 993.4 MiB
Name: atomic-master.localdomain
ID: NOJA:746G:NAE4:VET4:5ARY:BIY4:EAWA:4ORJ:ZMEZ:MSG6:DEX7:YW65
```

# Configure Docker Storage

## Stop Docker

```
# sudo systemctl stop docker
```

## Remove Default Storage

Remove the current docker pool, and enter _y_ to confirm removal.

```
# sudo lvremove /dev/atomicos/docker-pool
Do you really want to remove active logical volume docker-pool? [y/n]: *y*
  Logical volume "docker-pool" successfully removed
```

## Configure Docker Storage Setup

```
# sudo vi /etc/sysconfig/docker-storage-setup
```

Update it with the following:

```
VG=docker
DEVS=/dev/vdb
```

_NOTE: Update the device appropriately for your system.  i.e. for VirtualBox, it could be `/dev/sdb`_

## Run Docker Storage Setup

```
# sudo docker-storage-setup
  Volume group "docker" not found
  Cannot process volume group docker
0
Checking that no-one is using this disk right now ... OK

Disk /dev/vdb: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x2ee6b6f9.
Created a new partition 1 of type 'Linux LVM' and of size 10 GiB.
/dev/vdb2:
New situation:

Device     Boot Start      End  Sectors Size Id Type
/dev/vdb1        2048 20971519 20969472  10G 8e Linux LVM

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
  Physical volume "/dev/vdb1" successfully created
  Volume group "docker" successfully created
NOCHANGE: partition 2 is size 11966464. it cannot be grown
  Physical volume "/dev/vda2" changed
  1 physical volume(s) resized / 0 physical volume(s) not resized
  Rounding up size to full physical extent 12.00 MiB
  Logical volume "docker-meta" created.
  Logical volume "docker-data" created.
```

## Start Docker
```
# sudo systemctl start docker
```

# Reinspect the System

## Physical Volumes
```
# sudo pvs
  PV         VG       Fmt  Attr PSize  PFree
  /dev/vda2  atomicos lvm2 a--   5.70g   2.77g
  /dev/vdb1  docker   lvm2 a--  10.00g 208.00m
```

## Volume Groups
```
# sudo vgs
  VG       #PV #LV #SN Attr   VSize  VFree
  atomicos   1   1   0 wz--n-  5.70g   2.77g
  docker     1   2   0 wz--n- 10.00g 208.00m
```

## Logical Volumes
```
# sudo lvs
  LV          VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root        atomicos -wi-ao----  2.93g
  docker-data docker   -wi-a-----  9.78g
  docker-meta docker   -wi-a----- 12.00m
```

## Reinspect Docker Information

```
# sudo docker info
Containers: 0
Images: 0
Storage Driver: devicemapper
 Pool Name: docker-253:0-8473374-pool
 Pool Blocksize: 65.54 kB
 Backing Filesystem: xfs
 Data file: /dev/docker/docker-data
 Metadata file: /dev/docker/docker-meta
 Data Space Used: 11.8 MB
 Data Space Total: 10.5 GB
 Data Space Available: 10.49 GB
 Metadata Space Used: 77.82 kB
 Metadata Space Total: 12.58 MB
 Metadata Space Available: 12.51 MB
 Udev Sync Supported: true
 Library Version: 1.02.93 (2015-01-30)
Execution Driver: native-0.2
Kernel Version: 4.0.4-301.fc22.x86_64
Operating System: Fedora 22 (Twenty Two)
CPUs: 2
Total Memory: 993.4 MiB
Name: atomic-master.localdomain
ID: NOJA:746G:NAE4:VET4:5ARY:BIY4:EAWA:4ORJ:ZMEZ:MSG6:DEX7:YW65
```

# Download Docker Image

Let's see how much data space Docker currently uses:

```
# sudo docker info | grep 'Data Space Used'
 Data Space Used: 11.8 MB
```

Now, let's pull a Docker image and notice that the data goes into the pool:

```
# sudo docker pull docker.io/fedora/tools
latest: Pulling from docker.io/fedora/tools
48ecf305d2cf: Pull complete
ded7cd95e059: Pull complete
faa89fffe7d7: Pull complete
4ea26db2f85c: Pull complete
74fc05742791: Pull complete
d26be909cb61: Pull complete
1b077fbc313d: Pull complete
4022e4badd41: Pull complete
150b28944563: Pull complete
Digest: sha256:1112bba64266ad6229a9940039e99f93435e622262b1d07830292fcc046a13dc
Status: Downloaded newer image for docker.io/fedora/tools:latest
```

View how much data space Docker now uses:

```
# sudo docker info | grep 'Data Space Used'
 Data Space Used: 1.503 GB
```

Create a new container, writing 50MB of data *inside* the container. Note the container persists.

```
# sudo docker run docker.io/fedora/tools dd if=/dev/zero of=/var/tmp/data count=100000
100000+0 records in
100000+0 records out
51200000 bytes (51 MB) copied, 0.0789428 s, 649 MB/s
```

Now, let's see the status of our containers:

```
# sudo docker ps -a
CONTAINER ID        IMAGE                           COMMAND                CREATED              STATUS                          PORTS               NAMES
f562d2b5829a        docker.io/fedora/tools:latest   "dd if=/dev/zero of=   About a minute ago   Exited (0) About a minute ago                       stupefied_bell
```

Let's see how much storage we use now:

```
# sudo docker info | grep 'Data Space Used'
 Data Space Used: 1.561 GB
```

Notice how we have approximately 50MB more data space used?

Remove the stopped container and notice that the space is freed in Docker storage:

```
# sudo docker rm stupefied_bell
stupefied_bell
```

```
# sudo docker info |grep 'Data Space Used'
 Data Space Used: 1.503 GB
```

# Bind Mounts

Let's check our disk space of our host's root filesystem:

```
# df -h /
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/atomicos-root  3.0G  817M  2.2G  28% /
```

Create host directory, label it, use a bind mount to write 50MB of data *outside* the container

```
# sudo mkdir -p /var/local/containerdata
# sudo chcon -R -h -t svirt_sandbox_file_t /var/local/containerdata/
# sudo docker run --rm -v /var/local/containerdata:/var/tmp docker.io/fedora/tools dd if=/dev/zero of=/var/tmp/data count=100000
100000+0 records in
100000+0 records out
51200000 bytes (51 MB) copied, 0.0865377 s, 592 MB/s
```

Notice that we used `--rm`, so the container is automatically deleted after it runs.

Let's see what containers exist:

```
# sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

The container no longer exists, however, the data exists on the host filesystem:

```
# ls -al /var/local/containerdata
total 50000
drwxr-xr-x. 2 root root       17 Feb 27 20:40 .
drwxr-xr-x. 3 root root       26 Feb 27 20:39 ..
-rw-r--r--. 1 root root 51200000 Feb 27 20:40 data
```

The disk usage shown by `df -h` on the host will have increased, even after deleting the container.

```
# df -h /
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/atomicos-root  3.0G  865M  2.1G  29% /
```

Now, let's delete the data:

```
# sudo rm /var/local/containerdata/data
# ls -al /var/local/containerdata
total 0
drwxr-xr-x. 2 root root  6 Sep 24 18:19 .
drwxr-xr-x. 3 root root 26 Sep 24 18:18 ..
```

Now, let's check the disk space usage:

```
# df -h /
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/atomicos-root  3.0G  817M  2.2G  28% /
```

*This concludes the Configure Storage lab.*

[NEXT LAB](3_manageAtomicHosts.md)
