#!/bin/bash

ROOT="$HOME/.ntr/jails/$1"
if [ ! -d "$ROOT" ]; then
	echo "Root nao encontrada!"
	exit 1
fi

rm -rf "$ROOT"
