# Cheasy

Create debian chroots easily.

## Getting Started

I personally use it to create build machines.

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

