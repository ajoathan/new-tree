#!/bin/bash

if [ "$1" == "" ]; then
	echo "Especifique a jail!"
	exit 1
fi

ROOT="$HOME/.ntr/jails/$1"
if [ ! -d "$ROOT" ]; then
	echo "Jail nao encontrada!"
	exit 1
fi

rm -rf "$ROOT"
