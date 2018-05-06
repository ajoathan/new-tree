#!/bin/bash
HME="/root"
BINDS=""
PTH=".:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

SUITE="$(lsb_release -sc)"
ROOT="$SUITE"
MIRROR="http://localhost:3142/ftp.br.debian.org/debian/"

while [ "$1" != "" ]; do
	if [[ "$1" == "--mirror" || "$1" == "-m" ]]; then
		MIRROR="$2"
	elif [[ "$1" == "--suite" || "$1" == "-s" ]]; then
		SUITE="$2"
	elif [[ "$1" == "--home" || "$1" == "-h" ]]; then
		HME="$2"
	elif [[ "$1" == "--bind" || "$1" == "-b" ]]; then
		BINDS="$BINDS $2"
	else
		ROOT="$1"
		break
	fi
	shift 2
done

BINDS="$BINDS $ROOT"
for bind in $BINDS; do
	if [[ -e $bind ]]; then
		BIND="$BIND -b $bind:$HME/`basename $bind`"
	fi
done

ROOT="$HOME/.ntr/roots/$ROOT"
if [[ ! -d "$ROOT" ]]; then
	fakechroot fakeroot debootstrap --variant=minbase \
		"$SUITE" "$ROOT" "$MIRROR" &&
	rm -rf "$ROOT/proc" "$ROOT/sys" "$ROOT/dev"
fi &&

cp /etc/resolv.conf "$ROOT/etc/resolv.conf" &&
env -i DISPLAY=$DISPLAY HOME="$HME" PATH="$PTH" TERM=$TERM \
	proot -0 -w "$HME" -r "$ROOT" -b /proc -b /sys -b /dev \
	$BIND /bin/bash
