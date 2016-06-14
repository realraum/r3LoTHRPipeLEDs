#!/bin/zsh --extendedglob
local LUATOOL=${0:h}/tools/luatool.py
for f in *.lua~init.lua; do
	$LUATOOL $@ -f $f -c
done
#$LUATOOL $@ -f init.lua -r
