#!/bin/zsh --extendedglob
local LUATOOL=/home/bernhard/realraum/luatool/luatool/luatool.py
for f in *.lua~init.lua; do
	$LUATOOL $@ -f $f -c
done
#$LUATOOL $@ -f init.lua -r
