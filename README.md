# Cheasy

Create debian chroots easily.

## Getting Started

```
create_chroot.sh -h
usage: create_chroot.sh [options]
options:
        -h           : display this and exit
        -c           : create the chroot as a tarball
        -i           : install missing host package (binutils debootstrap)
        -a <arch>    : set arch type (default: amd64) (amd64 arm64 armel armhf i386 mips mipsel powerpc ppc64el s390x)
        -v <version> : set version type (default: jessie) (experimental jessie oldstable sid stable stretch testing unstable wheezy)
        -m <mirror>  : set the mirrot (default: http://deb.debian.org/debian/)
        -p <script>  : execute this script in the chroot (post-install)
```

### Example

Create a chroot for a build machine based on debian jessie:

```
create_chroot.sh -c -i -p post-install/post-builder.sh
```

Then, you can *chroot*:

```
root chroot-jessie-amd64 su - build
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

