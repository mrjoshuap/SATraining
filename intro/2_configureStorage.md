# Configure Storage

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Agenda](#agenda)
- [Inspect the System](#inspect-the-system)
  - [Physical Volumes](#physical-volumes)
  - [Volume Groups](#volume-groups)
  - [Logical Volumes](#logical-volumes)
  - [Inspect Docker Information](#inspect-docker-information)
- [Configure Docker Storage](#configure-docker-storage)
  - [Stop Docker](#stop-docker)
  - [Remove Default Storage](#remove-default-storage)
  - [Configure New Docker Storage Device](#configure-new-docker-storage-device)
  - [Run `docker-storage-setup`](#run-docker-storage-setup)
  - [Physical Volumes](#physical-volumes-1)
  - [Volume Groups](#volume-groups-1)
  - [Logical Volumes](#logical-volumes-1)
  - [Start Docker](#start-docker)
  - [Inspect Docker Information](#inspect-docker-information-1)
- [Download Docker Image](#download-docker-image)
- [Bind Mounts](#bind-mounts)
- [Configuration Merging](#configuration-merging)

<!-- /MarkdownTOC -->

## Agenda

1. Inspect and understand LVM setup
1. Configure docker storage
1. Inspect the updated LVM setup
1. Download images, write inside the container
1. Use bind mounts, write to bind mount
1. Configuration merging

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

## Configure New Docker Storage Device


```
# sudo vi /etc/sysconfig/docker-storage-setup
```

Update it with the following:

```
VG=docker
DEVS=/dev/vdb
```

_NOTE: Update the device appropriately for your system.  i.e. for VirtualBox, it could be `/dev/sdb`_

## Run `docker-storage-setup`

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

## Start Docker
```
# sudo systemctl start docker
```

## Inspect Docker Information

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

Pull a Docker image and notice that the data goes into the pool:

```
TODO: choose a different image
# docker pull registry.access.redhat.com/rhel7
# docker info |grep 'Data Space Used'
 Data Space Used: 177 MB
```

Create a new container, writing 50MB of data *inside* the container. Note the container persists.

```
TODO: choose a different image
# docker run registry.access.redhat.com/rhel7 dd if=/dev/zero of=/var/tmp/data count=100000
100000+0 records in
100000+0 records out
51200000 bytes (51 MB) copied, 0.0789428 s, 649 MB/s
# docker ps -a
TODO: Update with appropriate output
CONTAINER ID        IMAGE                                COMMAND                CREATED             STATUS                      PORTS               NAMES
6d645085a215        registry.access.redhat.com/rhel7:0   "dd if=/dev/zero of=   5 seconds ago      Exited (0) 4 seconds ago                       prickly_stallman
# docker info | grep 'Data Space Used'
  Data Space Used: 234.2 MB
```

Now, remove the stopped container and notice that the space is freed in Docker storage:

```
# docker rm <rhel7_container_id_or_name>
# docker info |grep 'Data Space Used'
 Data Space Used: 200.3 MB
```

# Bind Mounts

Create host directory, label it, use a bind mount to write 50MB of data *outside* the container

```
# mkdir -p /var/local/containerdata
# chcon -R -h -t svirt_sandbox_file_t /var/local/containerdata/
# docker run --rm -v /var/local/containerdata:/var/tmp registry.access.redhat.com/rhel7 dd if=/dev/zero of=/var/tmp/data count=100000
100000+0 records in
100000+0 records out
51200000 bytes (51 MB) copied, 0.0865377 s, 592 MB/s
```

Notice that we used `--rm`, so the container is automatically deleted after it runs. However, the data exists on the host filesystem:

```
# ls -al /var/local/containerdata
total 50000
drwxr-xr-x. 2 root root       17 Feb 27 20:40 .
drwxr-xr-x. 3 root root       26 Feb 27 20:39 ..
-rw-r--r--. 1 root root 51200000 Feb 27 20:40 data
```

The disk usage shown by `df -h` on the host will have increased, even after deleting the container.

# Configuration Merging

Explore configuration merging. Execute the following command to look at existing differences:

```
# ostree admin config-diff
M    adjtime
M    gshadow
M    hosts
M    libuser.conf
M    login.defs
M    nsswitch.conf
<snip>
```

* Create a file in _/etc/_

```
# touch /etc/somefile
```

* Ensure ostree is aware of the new file.


```
# ostree admin config-diff | grep somef
A    somefile
```

* Compare _/usr/etc_ to _etc_. Notice how _somefile_ is not in _/usr/etc_.

```
# ls /usr/etc/some*
ls: cannot access /usr/etc/some*: No such file or directory

# ls /etc/some*
/etc/somefile
```

*This concludes the Configure Storage lab.*

[NEXT LAB](3_manageAtomicHosts.md)
