# Install Atomic Tools

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Install Atomic Tools](#install-atomic-tools)
- [Using atomic-tools](#using-atomic-tools)

<!-- /MarkdownTOC -->

## Install Atomic Tools

```
atomic install rhel7/rhel-tools
```

This will install the atomic-tools container, which can be used as the administrator's shell.

Now let's try:

```
atomic run rhel7/rhel-tools man tcpdump
atomic run rhel7/rhel-tools tcpdump
```

You can also go into the atomic-tools container and explore its contents.

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

This script makes using man pages transparent to the user (even though man pages are not installed on the Atomic Host, only in the atomic-tools container).
It could also be done with a bash alias.

```
man tcpdump
```

atomic-tools is a Super Privileged Container, which will be covered in the next presentation and lab.

## Using atomic-tools

As we saw in the previous labs, the atomic-tools container provides the core system administrator and core developer tools to execute tasks on Red Hat Enterprise Linux 7 Atomic Host. The tools container leverages the atomic command for installation, activation and management.

* Install the atomic-tools container. You can do this on whichever system you want to be node 1.

```
# atomic install [REGISTRY]/rhel7/rhel-tools
Pulling repository [REGISTRY]/rhel7/rhel-tools
9a8ad4567c27: Download complete
Status: Downloaded newer image for [REGISTRY]/rhel7/rhel-tools:latest
```

Run the atomic-tools container. Notice how you are dropped to the prompt inside the container.

```
# atomic run [REGISTRY]/rhel7/rhel-tools
docker run -it --name atomic-tools --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=atomic-tools -e IMAGE=[REGISTRY]/rhel7/rhel-tools -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host [REGISTRY]/rhel7/rhel-tools
[root@atomic-00 /]#
```

* Remember those commands at the end of the Atomic deployment lab? The ones that did not work? Try them again.

```
man tcpdump

git

tcpdump

sosreport
```

* Explore the environment. Check processes:

```
# ps aux
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root          1  0.0  0.1  61880  7720 ?        Ss   Feb20   0:03 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
root          2  0.0  0.0      0     0 ?        S    Feb20   0:00 [kthreadd]
root          3  0.0  0.0      0     0 ?        S    Feb20   0:15 [ksoftirqd/0]
root          5  0.0  0.0      0     0 ?        S<   Feb20   0:00 [kworker/0:0H]
root          7  0.0  0.0      0     0 ?        S    Feb20   0:00 [migration/0]
<snip>
```

* Check the environment variables:

```
# env
HOSTNAME=atomic-00.localdomain
HOST=/host
TERM=xterm
NAME=atomic-tools
```

* Run an sosreport. Notice where it is saved to, the sosreport tool has been modified to work in a container environment.

```
# sosreport

sosreport (version 3.2)

This command will collect diagnostic and configuration information from
this Red Hat Atomic Host system.

<snip>

Your sosreport has been generated and saved in:
  /host/var/tmp/sosreport-scollier.12344321-20150225144723.tar.xz

The checksum is: 9de2decce230cd4b2b84ab4f41ec926e

Please send this file to your support representative.
```

Notice that the host os is mounted into /host within the container.

```
chroot /host
```

You are back in the host.

```
^d
```

You are back in the container. You may also notice that /run is from the host
and you see the host's network and processes, but you are still in a container.

Let's play around a little more.

* Clone a git repo, and save the repo to the host filesystem, not to the image filesystem.

```
# git clone https://github.com/GoogleCloudPlatform/kubernetes.git /host/tmp/kubernetes
Cloning into '/host/tmp/kubernetes'...
remote: Counting objects: 48730, done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 48730 (delta 7), reused 0 (delta 0), pack-reused 48708
Receiving objects: 100% (48730/48730), 30.44 MiB | 9.63 MiB/s, done.
Resolving deltas: 100% (32104/32104), done.
```

Exit the container and look at the git repo and the sosreport output. Hit CTRL-D to exit the container, or type _exit_.

```
# ls {/tmp,/var/tmp/}
/tmp:
ks-script-K46kdd  ks-script-Si6KRr  kubernetes

/var/tmp/:
sosreport-scollier.12344321-20150225144723.tar.xz  sosreport-scollier.12344321-20150225144723.tar.xz.md5
```

```
less /var/log/messages
```
Notice on a RHEL Atomic Host there is no syslog by default. You can look at the log messages using journald.

```
journalctl
```

If you want to use rsyslog on your host, you need to install the rsyslog SPC container.


*This concludes the Install Tools lab.*

[NEXT LAB](6_spcContainers.md)
