#!/bin/bash
HME="/root"
PTH=".:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

SUITE="xenial"
ROOT="$SUITE"

function bootstrap() {
	http_proxy="$PROXY" fakechroot fakeroot \
		debootstrap --variant=minbase $@ &&
	echo "Acquire::http::Proxy \"$PROXY\";" >> "$ROOT/etc/apt/apt.conf" &&
	rm -rf "$2/proc" "$2/sys" "$2/dev"
}

while [ "$1" != "" ]; do
	if [[ "$1" == "--mirror" || "$1" == "-m" ]]; then
		MIRROR="$2"
	elif [[ "$1" == "--suite" || "$1" == "-s" ]]; then
		SUITE="$2"
	elif [[ "$1" == "--home" || "$1" == "-h" ]]; then
		HME="$2"
	elif [[ "$1" == "--bind" || "$1" == "-b" ]]; then
		BINDS="$BINDS $2"
	elif [[ "$1" == "--proxy" || "$1" == "-p" ]]; then
		PROXY="$2"
	else
		ROOT="$1"
		shift
		if [[ "$1" == "" ]]; then
			CMD="/bin/bash"
		else
			CMD="$@"
		fi
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

ROOT="$HOME/.ntr/jails/$ROOT"
if [[ ! -d "$ROOT" ]]; then
	bootstrap "$SUITE" "$ROOT" "$MIRROR"
fi &&

cp /etc/resolv.conf "$ROOT/etc/resolv.conf" &&
env -i PROOT_NO_SECCOMP=1 DISPLAY=$DISPLAY HOME="$HME" PATH="$PTH" TERM=$TERM \
	proot -0 -w "$HME" -r "$ROOT" -b /proc -b /sys -b /dev $BIND $CMD
