# Manage Atomic Hosts

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Agenda](#agenda)
  - [Begin](#begin)
- [Atomic Host Status](#atomic-host-status)
  - [Fedora Atomic Host](#fedora-atomic-host)
  - [CentOS Atomic](#centos-atomic)
  - [Red Hat Enterprise Linux Atomic Host](#red-hat-enterprise-linux-atomic-host)
- [Update Atomic Hosts](#update-atomic-hosts)
- [Rollback Atomic Host](#rollback-atomic-host)
- [Configuration Merging](#configuration-merging)

<!-- /MarkdownTOC -->

## Agenda

1. Get the status of an atomic host
1. Update an atomic host
1. Rollback an atomic host
1. Review configuration merging

### Begin

_NOTE: We will be working on only the `atomic-master`._

* Login to the `atomic-master`

# Atomic Host Status

_NOTE: Depending on the version of Atomic that you initially installed, some of the sample output below may differ from what you see._

## Fedora Atomic Host
```
# sudo atomic host status
  TIMESTAMP (UTC)         VERSION   ID             OSNAME            REFSPEC
* 2015-05-21 19:01:46     22.17     06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
```

## CentOS Atomic
```
# atomic status
  TIMESTAMP (UTC)         VERSION     ID             OSNAME               REFSPEC
* 2015-02-17 22:30:38     7.1.244     23cbd4dff5     centos-atomic        centos-atomic:centos-atomic/7/x86_64/standard
```

## Red Hat Enterprise Linux Atomic Host

```
# atomic host status
  TIMESTAMP (UTC)         VERSION     ID             OSNAME               REFSPEC
* 2015-02-17 22:30:38     7.1.244     27baa6dee2     rhel-atomic-host     rhel-atomic-host:rhel-atomic-host/7/x86_64/standard

# subscription-manager register --serverurl=[stage] --baseurl=[stage] --username=[account_user] --password=[account_pass] --auto-attach
```

# Update Atomic Hosts

The following commands will upgrade your Atomic Host.

_NOTE: The below output is an example, some of the sample output below may differ from what you see._

```
# sudo atomic host upgrade
Updating from: fedora-atomic:fedora-atomic/f22/x86_64/docker-host

1003 metadata, 6983 content objects fetched; 262501 KiB transferred in 159 seconds
Copying /etc changes: 25 modified, 0 removed, 48 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Changed:
  NetworkManager-1:1.0.6-5.fc22.x86_64
  NetworkManager-libnm-1:1.0.6-5.fc22.x86_64
  PyYAML-3.11-9.fc22.x86_64
  atomic-1.1-1.git5f631c8.fc22.x86_64
  ... <snip> ...
  vim-minimal-2:7.4.827-1.fc22.x86_64
  xfsprogs-3.2.2-2.fc22.x86_64
Removed:
  docker-storage-setup-0.0.4-2.fc22.noarch
  pciutils-libs-3.3.0-1.fc22.x86_64
  python-backports-1.0-5.fc22.x86_64
  python-backports-ssl_match_hostname-3.4.0.2-4.fc22.noarch
Added:
  docker-selinux-1.8.2-1.gitf1db8f2.fc22.x86_64
  elfutils-default-yama-scope-0.163-3.fc22.noarch
  iptables-services-1.4.21-14.fc22.x86_64
  kubernetes-client-1.1.0-0.5.gite44c8e6.fc22.x86_64
  ... <snip> ...
  python-setuptools-17.1.1-3.fc22.noarch
  socat-1.7.2.4-4.fc22.x86_64
Upgrade prepared for next boot; run "systemctl reboot" to start a reboot
```

Check the atomic tree version. The asterisk indicates the currently running tree. The tree displayed first in the list is the version that will be booted into. In the output below, if the system is rebooted, it will boot into the new 7.1.0 tree.

```
# sudo atomic host status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC
  2015-09-24 08:13:26     22.124     1b6d82b298     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
* 2015-05-21 19:01:46     22.17      06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
```

Reboot to switch to the updated tree.

```
# sudo systemctl reboot
```

Check your version with the atomic command. The `*` pointer should now be on the new tree.

```
# sudo atomic host status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC
* 2015-09-24 08:13:26     22.124     1b6d82b298     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
  2015-05-21 19:01:46     22.17      06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
```

# Rollback Atomic Host

```
# sudo atomic host rollback
Moving '06a63ecfcf053d1625e9ddf406429eef3c7fe3ecccbe636a54b90175a5899e7d.0' to be first deployment
Transaction complete; bootconfig swap: yes deployment count change: 0
Changed:
  NetworkManager-1:1.0.2-1.fc22.x86_64
  NetworkManager-libnm-1:1.0.2-1.fc22.x86_64
  PyYAML-3.11-7.fc22.x86_64
  atomic-0-0.7.gita7ff4cb.fc22.x86_64
  ... <snip> ...
  vim-minimal-2:7.4.640-4.fc22.x86_64
  xfsprogs-3.2.2-1.fc22.x86_64
Removed:
  docker-selinux-1.8.2-1.gitf1db8f2.fc22.x86_64
  elfutils-default-yama-scope-0.163-3.fc22.noarch
  iptables-services-1.4.21-14.fc22.x86_64
  kubernetes-client-1.1.0-0.5.gite44c8e6.fc22.x86_64
  ... <snip> ...
  python-setuptools-17.1.1-3.fc22.noarch
  socat-1.7.2.4-4.fc22.x86_64
Added:
  docker-storage-setup-0.0.4-2.fc22.noarch
  pciutils-libs-3.3.0-1.fc22.x86_64
  python-backports-1.0-5.fc22.x86_64
  python-backports-ssl_match_hostname-3.4.0.2-4.fc22.noarch
Sucessfully reset deployment order; run "systemctl reboot" to start a reboot
```

Reboot to switch to the previous tree.

```
# sudo systemctl reboot
```

Check your version with the atomic command. The `*` pointer should now be on the old tree.

```
# sudo atomic host status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC
* 2015-05-21 19:01:46     22.17      06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
  2015-09-24 08:13:26     22.124     1b6d82b298     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
```

Now, let's perform the upgrade again, so we are running the newest version:

```
sudo atomic host upgrade
Updating from: fedora-atomic:fedora-atomic/f22/x86_64/docker-host


Copying /etc changes: 25 modified, 0 removed, 48 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Changed:
  NetworkManager-1:1.0.6-5.fc22.x86_64
  NetworkManager-libnm-1:1.0.6-5.fc22.x86_64
  PyYAML-3.11-9.fc22.x86_64
  atomic-1.1-1.git5f631c8.fc22.x86_64
  ... <snip> ...
  vim-minimal-2:7.4.827-1.fc22.x86_64
  xfsprogs-3.2.2-2.fc22.x86_64
Removed:
  docker-storage-setup-0.0.4-2.fc22.noarch
  pciutils-libs-3.3.0-1.fc22.x86_64
  python-backports-1.0-5.fc22.x86_64
  python-backports-ssl_match_hostname-3.4.0.2-4.fc22.noarch
Added:
  docker-selinux-1.8.2-1.gitf1db8f2.fc22.x86_64
  elfutils-default-yama-scope-0.163-3.fc22.noarch
  iptables-services-1.4.21-14.fc22.x86_64
  kubernetes-client-1.1.0-0.5.gite44c8e6.fc22.x86_64
  ... <snip> ...
  python-setuptools-17.1.1-3.fc22.noarch
  socat-1.7.2.4-4.fc22.x86_64
Upgrade prepared for next boot; run "systemctl reboot" to start a reboot
```

Reboot to switch to the updated tree.

```
# sudo systemctl reboot
```

Check your version with the atomic command. The `*` pointer should now be on the new tree.

```
# sudo atomic host status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC
* 2015-09-24 08:13:26     22.124     1b6d82b298     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
  2015-05-21 19:01:46     22.17      06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
```

# Configuration Merging

Explore configuration merging. Execute the following command to look at existing differences:

```
# sudo ostree admin config-diff
M    adjtime
M    gshadow
M    hosts
M    libuser.conf
M    login.defs
M    nsswitch.conf
<snip>
```

Create a file in _/etc/_

```
# sudo touch /etc/somefile
```

Ensure ostree is aware of the new file.

```
# sudo ostree admin config-diff | grep somef
A    somefile
```

Compare _/usr/etc_ to _etc_. Notice how _somefile_ is not in _/usr/etc_.

```
# ls /usr/etc/some*
ls: cannot access /usr/etc/some*: No such file or directory

# ls /etc/some*
/etc/somefile
```

[NEXT LAB](4_svcContainers.md)
