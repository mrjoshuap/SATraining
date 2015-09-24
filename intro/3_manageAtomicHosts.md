# Manage Atomic Hosts

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Begin](#begin)
- [Atomic Host Status](#atomic-host-status)
  - [Fedora Atomic Host](#fedora-atomic-host)
  - [CentOS Atomic](#centos-atomic)
  - [Red Hat Enterprise Linux Atomic Host](#red-hat-enterprise-linux-atomic-host)
  - [Update Atomic Hosts](#update-atomic-hosts)
- [Configuration Merging](#configuration-merging)

<!-- /MarkdownTOC -->

## Begin

_NOTE: We will be working on only the `atomic-master`._

* Login to the `atomic-master`

# Atomic Host Status

_NOTE: Depending on the version of Atomic that you initially installed, some of the sample output below may differ from what you see._

## Fedora Atomic Host
```
# atomic status
  TIMESTAMP (UTC)         ID             OSNAME            REFSPEC
* 2014-12-03 01:30:09     ba7ee9475c     fedora-atomic     fedora-atomic:fedora-atomic/f21/x86_64/docker-host
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

## Update Atomic Hosts

Update all of the Atomic Hosts. The following commands will upgrade your Atomic Host.

_NOTE: The below output is an example, some of the sample output below may differ from what you see._

```bash
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

[NEXT LAB](4_svcContainers.md)
