#!/bin/bash
cd $(dirname "$0")

export VER=`cat src/info.json | grep \"version\" | sed -r 's/.*: \"([0-9]+\.[0-9]+\.[0-9]+)\".*/\1/'`

if [ -d bin ]; then
	if [ -d bin/Surfaces_"$VER" ]; then
		cp -f bin/Surfaces_"$VER".zip ~/.factorio/mods/Surfaces_"$VER".zip
		steam -applaunch 427520
	fi
fi