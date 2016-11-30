#!/usr/bin/env bash

#
# A simple script to easily create chroot for debian
#
# see: https://wiki.debian.org/Debootstrap
#

# create the chroot as a tarball
TARBALL=false

# define the arch for the chroot: amd64|arm64|armel|armhf|i386|mips|mipsel|powerpc|ppc64el|s390x
ARCH=amd64
ALL_ARCH="amd64 arm64 armel armhf i386 mips mipsel powerpc ppc64el s390x"

# define the debian version to use: experimental|jessie|oldstable|sid|stable|stretch|testing|unstable|wheezy
VERSION=jessie
ALL_VERSION="experimental jessie oldstable sid stable stretch testing unstable wheezy"

# define the webserver where to grab the chroot (see https://www.debian.org/mirror/list)
SERVER=http://deb.debian.org/debian/

# define the output for the created chroot
CHROOT="chroot-$VERSION-$ARCH"

# define the needed packages
HOST_PKGS="binutils debootstrap"
HOST_INSTALL=false

# define the post-install script for the chroot
POST_SCRIPT=""


function usage()
{
	echo "usage: $(basename $0) [options]"
	echo "options:"
	echo -e "\t-h           : display this and exit"
	echo -e "\t-c           : create the chroot as a tarball"
	echo -e "\t-i           : install missing host package ($HOST_PKGS)"
	echo -e "\t-a <arch>    : set arch type (default: $ARCH) ($ALL_ARCH)"
	echo -e "\t-v <version> : set version type (default: $VERSION) ($ALL_VERSION)"
	echo -e "\t-m <mirror>  : set the mirrot (default: $SERVER)"
	echo -e "\t-p <script>  : execute this script in the chroot (post-install)"
}


function check_pkg()
{
	local pkg=$1

	if [ -z "$(dpkg -l | grep $pkg)" ]; then
		if [ $HOST_INSTALL ]; then
			sudo apt-get install -y $pkg
		else
			echo "$pkg is not installed. You can install it by typing:"
			echo "sudo apt-get install $pkg"
			exit 1
		fi
	fi
}


function check_host_pkg()
{
	local pkg

	for pkg in $HOST_PKGS; do
		check_pkg "$pkg"
	done
}


function check_opt()
{
	while getopts ":hcia:v:m:p:" opt; do
		case $opt in
		 h)
		 usage
		 exit 0
		 ;;

		 c)
		 TARBALL=true
		 ;;

		 i)
		 HOST_INSTALL=true
		 ;;

		 a)
		 ARCH=$OPTARG
		 ;;

		 v)
		 VERSION=$OPTARG
		 ;;

		 m)
		 SERVER=$OPTARG
		 ;;

		 p)
		 POST_SCRIPT=$OPTARG
		 ;;

		 \?)
		 echo "Invalid option: -$OPTARG" >&2
		 exit 1
		 ;;

		 :)
		 echo "Option -$OPTARG requires an argument." >&2
		 exit 1
		 ;;
		esac
	done
}


function do_chroot()
{
	echo "Trying to create chroot $CHROOT"
	mkdir -p ${CHROOT}
	sudo debootstrap --arch $ARCH $VERSION $CHROOT $SERVER
}


function do_postscript()
{
	[ -z "$POST_SCRIPT" ] && return
	[ -f "$POST_SCRIPT" ] || (echo "$POST_SCRIPT is not a regular file. Exiting..."; exit 1;)

	sudo cp "$POST_SCRIPT" "$CHROOT"/root/postscript
	sudo chmod +x "$CHROOT"/root/postscript
	sudo chroot "$CHROOT" /root/postscript
	sudo rm "$CHROOT"/root/postscript
}


function do_tarball()
{
	[ ! $TARBALL ] && return

	sudo tar cvzf $CHROOT.tgz $CHROOT
	sudo rm -rf $CHROOT
	CHROOT+=".tgz"
}


function main()
{
	check_opt $@
	check_host_pkg

	do_chroot
	do_postscript
	do_tarball

	echo -e "\ndebian chroot created in $CHROOT\n"
}


main $@
