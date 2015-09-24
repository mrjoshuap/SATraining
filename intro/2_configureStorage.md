# Configure Storage

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Agenda](#agenda)
- [Inspect the System](#inspect-the-system)
  - [Physical Volumes](#physical-volumes)
  - [Volume Groups](#volume-groups)
  - [Logical Volumes](#logical-volumes)
- [Configure Docker Storage](#configure-docker-storage)
  - [Stop Docker](#stop-docker)
  - [Remove Default Storage](#remove-default-storage)
  - [Edit /etc/sysconfig/docker-storage-setup](#edit-etcsysconfigdocker-storage-setup)
  - [Run `docker-storage-setup`](#run-docker-storage-setup)
- [Download Docker Image](#download-docker-image)
- [Bind Mounts](#bind-mounts)
- [Configuration Merging](#configuration-merging)

<!-- /MarkdownTOC -->

## Agenda

1. Inspect and understand LVM setup
1. Configure docker storage
1. Download images, write inside the container
1. Use bind mounts, write to bind mount
1. Configuration merging

# Inspect the System

Take note of the automatic storage configuration for Docker by looking at the physical volumes, volume groups and logical volumes. An Atomic Host comes optimized out of the box to take advantage of LVM thinpool storage, instead of the loopback used with Docker by default.

### Physical Volumes
```
# pvs
TODO: Update with appropriate output
```

### Volume Groups
```
# vgs
TODO: Update with appropriate output
```

### Logical Volumes
```
# lvs
TODO: Update with appropriate output
```

* Now see how that corresponds to the Docker image and container storage:

```
# docker info
TODO: Update with appropriate output
```

# Configure Docker Storage

## Stop Docker

```
systemctl stop docker
TODO: Update with appropriate output
```

## Remove Default Storage

```
lvremove docker-pool
TODO: Update with appropriate output
```

## Edit /etc/sysconfig/docker-storage-setup

```
VG=docker
DEVS=/dev/vdb
```

## Run `docker-storage-setup`

```
# docker-storage-setup
TODO: Update with appropriate output
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
# docker info |grep 'Data Space Used'
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
