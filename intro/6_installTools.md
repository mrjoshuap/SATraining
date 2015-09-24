# Install Tools

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Install Atomic Tools](#install-atomic-tools)

<!-- /MarkdownTOC -->


# Install Atomic Tools

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

*This concludes the Install Tools lab.*
