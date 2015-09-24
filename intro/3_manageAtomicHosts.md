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

## Update Atomic Hosts

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
  audit-2.4.4-1.fc22.x86_64
  audit-libs-2.4.4-1.fc22.x86_64
  audit-libs-python-2.4.4-1.fc22.x86_64
  avahi-autoipd-0.6.31-32.fc22.x86_64
  avahi-libs-0.6.31-32.fc22.x86_64
  bash-4.3.42-1.fc22.x86_64
  bash-completion-1:2.1-7.20150513git1950590.fc22.noarch
  bind99-libs-9.9.7-7.P3.fc22.x86_64
  bind99-license-9.9.7-7.P3.fc22.noarch
  btrfs-progs-4.2-1.fc22.x86_64
  ca-certificates-2015.2.5-1.0.fc22.noarch
  cockpit-bridge-0.67-1.fc22.x86_64
  cockpit-docker-0.67-1.fc22.x86_64
  cockpit-shell-0.67-1.fc22.noarch
  coreutils-8.23-11.fc22.x86_64
  cryptsetup-1.6.8-2.fc22.x86_64
  cryptsetup-libs-1.6.8-2.fc22.x86_64
  curl-7.40.0-7.fc22.x86_64
  cyrus-sasl-lib-2.1.26-23.fc22.x86_64
  dbus-1:1.8.20-1.fc22.x86_64
  dbus-libs-1:1.8.20-1.fc22.x86_64
  device-mapper-persistent-data-0.5.5-1.fc22.x86_64
  docker-1.8.2-1.gitf1db8f2.fc22.x86_64
  dracut-041-14.fc22.x86_64
  dracut-config-generic-041-14.fc22.x86_64
  dracut-network-041-14.fc22.x86_64
  efibootmgr-0.12-1.fc22.x86_64
  efivar-libs-0.20-1.fc22.x86_64
  elfutils-libelf-0.163-3.fc22.x86_64
  elfutils-libs-0.163-3.fc22.x86_64
  etcd-2.0.13-2.fc22.x86_64
  file-5.22-4.fc22.x86_64
  file-libs-5.22-4.fc22.x86_64
  flannel-0.5.0-3.fc22.x86_64
  glibc-2.21-7.fc22.x86_64
  glibc-common-2.21-7.fc22.x86_64
  gnupg2-2.1.7-1.fc22.x86_64
  gnutls-3.3.18-1.fc22.x86_64
  gzip-1.6-8.fc22.x86_64
  hawkey-0.6.0-1.fc22.x86_64
  hwdata-0.282-1.fc22.noarch
  info-5.2-9.fc22.x86_64
  kernel-4.1.7-200.fc22.x86_64
  kernel-core-4.1.7-200.fc22.x86_64
  kernel-modules-4.1.7-200.fc22.x86_64
  kmod-21-1.fc22.x86_64
  kmod-libs-21-1.fc22.x86_64
  kpartx-0.4.9-73.fc22.1.x86_64
  krb5-libs-1.13.2-5.fc22.x86_64
  kubernetes-1.1.0-0.5.gite44c8e6.fc22.x86_64
  less-471-5.fc22.x86_64
  libassuan-2.3.0-1.fc22.x86_64
  libbasicobjects-0.1.1-27.fc22.x86_64
  libblkid-2.26.2-3.fc22.x86_64
  libcap-ng-0.7.5-2.fc22.x86_64
  libcollection-0.7.0-27.fc22.x86_64
  libcurl-7.40.0-7.fc22.x86_64
  libdb-5.3.28-12.fc22.x86_64
  libdb-utils-5.3.28-12.fc22.x86_64
  libfdisk-2.26.2-3.fc22.x86_64
  libgcc-5.1.1-4.fc22.x86_64
  libgomp-5.1.1-4.fc22.x86_64
  libgsystem-2015.1-2.fc22.x86_64
  libgudev1-219-24.fc22.x86_64
  libidn-1.32-1.fc22.x86_64
  libini_config-1.2.0-27.fc22.x86_64
  libmount-2.26.2-3.fc22.x86_64
  libpath_utils-0.2.1-27.fc22.x86_64
  libpcap-14:1.7.3-1.fc22.x86_64
  libpwquality-1.2.4-3.fc22.x86_64
  libref_array-0.1.5-27.fc22.x86_64
  libreport-filesystem-2.6.2-4.fc22.x86_64
  libseccomp-2.2.3-0.fc22.x86_64
  libselinux-2.3-10.fc22.x86_64
  libselinux-python-2.3-10.fc22.x86_64
  libselinux-utils-2.3-10.fc22.x86_64
  libsmartcols-2.26.2-3.fc22.x86_64
  libsolv-0.6.11-2.fc22.x86_64
  libstdc++-5.1.1-4.fc22.x86_64
  libtalloc-2.1.3-1.fc22.x86_64
  libtevent-0.9.25-1.fc22.x86_64
  libtirpc-0.3.2-2.0.fc22.x86_64
  libudisks2-2.1.6-1.fc22.x86_64
  libuser-0.62-1.fc22.x86_64
  libuuid-2.26.2-3.fc22.x86_64
  libxml2-2.9.2-4.fc22.x86_64
  libxml2-python-2.9.2-4.fc22.x86_64
  linux-firmware-20150904-56.git6ebf5d57.fc22.noarch
  nfs-utils-1:1.3.2-9.fc22.x86_64
  nss-3.20.0-1.0.fc22.x86_64
  nss-softokn-3.20.0-1.0.fc22.x86_64
  nss-softokn-freebl-3.20.0-1.0.fc22.x86_64
  nss-sysinit-3.20.0-1.0.fc22.x86_64
  nss-tools-3.20.0-1.0.fc22.x86_64
  nss-util-3.20.0-1.0.fc22.x86_64
  ntfs-3g-2:2015.3.14-2.fc22.x86_64
  ntfsprogs-2:2015.3.14-2.fc22.x86_64
  openssh-6.9p1-7.fc22.x86_64
  openssh-clients-6.9p1-7.fc22.x86_64
  openssh-server-6.9p1-7.fc22.x86_64
  openssl-1:1.0.1k-12.fc22.x86_64
  openssl-libs-1:1.0.1k-12.fc22.x86_64
  ostree-2015.6-2.fc22.x86_64
  ostree-grub2-2015.6-2.fc22.x86_64
  p11-kit-0.23.1-2.fc22.x86_64
  p11-kit-trust-0.23.1-2.fc22.x86_64
  pam-1.1.8-19.fc22.x86_64
  parted-3.2-9.fc22.x86_64
  pcre-8.37-4.fc22.x86_64
  pinentry-0.9.2-1.fc22.x86_64
  policycoreutils-2.3-17.fc22.x86_64
  policycoreutils-python-2.3-17.fc22.x86_64
  polkit-0.113-4.fc22.x86_64
  polkit-libs-0.113-4.fc22.x86_64
  procps-ng-3.3.10-8.fc22.x86_64
  python-2.7.10-4.fc22.x86_64
  python-jsonpointer-1.9-2.fc22.noarch
  python-libs-2.7.10-4.fc22.x86_64
  python-requests-2.7.0-6.fc22.noarch
  python-sssdconfig-1.13.0-4.fc22.noarch
  python-urllib3-1.10.4-5.20150503gita91975b.fc22.noarch
  python-websocket-client-0.32.0-1.fc22.noarch
  python3-3.4.2-6.fc22.x86_64
  python3-libs-3.4.2-6.fc22.x86_64
  python3-setuptools-17.1.1-3.fc22.noarch
  rpcbind-0.2.3-0.1.fc22.x86_64
  rpm-4.12.0.1-12.fc22.x86_64
  rpm-libs-4.12.0.1-12.fc22.x86_64
  rpm-plugin-selinux-4.12.0.1-12.fc22.x86_64
  screen-4.3.1-1.fc22.x86_64
  selinux-policy-3.13.1-128.13.fc22.noarch
  selinux-policy-targeted-3.13.1-128.13.fc22.noarch
  shared-mime-info-1.4-6.fc22.x86_64
  sqlite-3.8.10.2-1.fc22.x86_64
  strace-4.10-2.fc22.x86_64
  sudo-1.8.14p3-1.fc22.x86_64
  systemd-219-24.fc22.x86_64
  systemd-libs-219-24.fc22.x86_64
  tar-2:1.28-6.fc22.x86_64
  tcpdump-14:4.7.4-2.fc22.x86_64
  tzdata-2015f-1.fc22.noarch
  udisks2-2.1.6-1.fc22.x86_64
  util-linux-2.26.2-3.fc22.x86_64
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
  kubernetes-master-1.1.0-0.5.gite44c8e6.fc22.x86_64
  kubernetes-node-1.1.0-0.5.gite44c8e6.fc22.x86_64
  libpipeline-1.4.0-1.fc22.x86_64
  man-db-2.7.1-8.fc22.x86_64
  python-pip-6.0.8-1.fc22.noarch
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
