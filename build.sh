#!/bin/bash
cd $(dirname "$0")

export VER=`cat src/info.json | grep \"version\" | sed -r 's/.*: \"([0-9]+\.[0-9]+\.[0-9]+)\".*/\1/'`

if [ ! -d bin ]; then
	mkdir bin
fi
if [ ! -d bin/Surfaces_"$VER" ]; then
	mkdir bin/Surfaces_"$VER"
fi

cd src && cp -r -f . ../bin/Surfaces_"$VER"
cd ../bin && zip -r Surfaces_"$VER".zip Surfaces_"$VER"