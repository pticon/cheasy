#!/bin/bash

#
# The basics packages in order to create a debian builder
#
PKGS="gcc"
PKGS+=" g++"
PKGS+=" linux-image-amd64"
PKGS+=" linux-headers-3.16.0-4-amd64"
PKGS+=" autoconf"
PKGS+=" automake"
PKGS+=" autopoint"
PKGS+=" bison"
PKGS+=" build-essential"
PKGS+=" bzip2" 
PKGS+=" checkinstall"
PKGS+=" cmake"
PKGS+=" curl"
PKGS+=" debhelper"
PKGS+=" devscripts"
PKGS+=" dh-make" 
PKGS+=" dh-autoreconf"
PKGS+=" dpkg-dev"
PKGS+=" fakeroot"
PKGS+=" flex"
PKGS+=" fontconfig-config"
PKGS+=" fp-compiler"
PKGS+=" gawk"
PKGS+=" gdc"
PKGS+=" gdb"
PKGS+=" gettext" 
PKGS+=" gperf"
PKGS+=" gzip"
PKGS+=" make"
PKGS+=" nasm"
PKGS+=" ncurses-bin"
PKGS+=" patch"
PKGS+=" patchutils"
PKGS+=" pkg-config"
PKGS+=" pmount"
PKGS+=" shtool"
PKGS+=" tar"
PKGS+=" unzip"
PKGS+=" vim"
PKGS+=" wget"
PKGS+=" xtrans-dev"
PKGS+=" yasm"
PKGS+=" zip"
PKGS+=" zlib1g-dev"



function install_pkg()
{
	local list=/etc/apt/sources.list

	echo 'deb http://ftp.debian.org/debian/ jessie main contrib non-free' > $list
	echo 'deb http://security.debian.org/ jessie/updates main contrib non-free' >> $list
	apt-get clean
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -y
	apt-get update -y
	apt-get install -y $PKGS
}


function add_user()
{
	useradd -ms /bin/bash build
}


function clean_up()
{
	apt-get clean
	rm -fr /tmp/*
}


function main()
{
	install_pkg
	add_user
	clean_up
}


main
