# libvirt remote
A [Unified Remote](https://www.unifiedremote.com/) custom remote
for starting and stopping virtual machines managed by [libvirt](https://libvirt.org).

## Requirements
This remote executes `sudo virsh` commands. Below is the minimum list of commands
that the user must be allowed to execute with the `NOPASSWD` tag.
```
/usr/bin/virsh list *
/usr/bin/virsh start *
/usr/bin/virsh shutdown *
/usr/bin/virsh destroy *
```

## Installation
Clone this repository to a subdirectory of the `~/.urserver/remotes/custom` directory.
