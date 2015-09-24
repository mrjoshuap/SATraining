# Configure Atomic Hosts

<!-- MarkdownTOC depth=4 autolink=true bracket=round -->

- [Configure Private Docker Registry](#configure-private-docker-registry)
- [Configure Local ostree Repository](#configure-local-ostree-repository)

<!-- /MarkdownTOC -->

## Configure Private Docker Registry

Integrating a private registry is an important use case for customers. For this lab, we add a private registry, hosted on the Atomic Master, to pull and search images.

* Edit the `/etc/sysconfig/docker` file:

```
ADD_REGISTRY='--add-registry atomic-master'
```

_NOTE: If the private registry is not configured with a CA-signed SSL certificate `docker pull ...` will fail with a message about an insecure registry._  In that case, add the following line to `/etc/sysconfig/docker`:

```
INSECURE_REGISTRY='--insecure-registry atomic-master'
```

* Restart docker

```
systemctl restart docker
```

## Configure Local ostree Repository

For this lab, we want to ensure we are getting our updates from a local repository for performance and network purposes.

*This concludes the Configure Atomic Hosts lab.*

[NEXT LAB](5_deployApplications.md)
