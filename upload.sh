#!/bin/zsh
local LUATOOL=~r3/luatool/luatool/luatool.py
for f in *.lua~init.lua do
	$LUATOOL $@ -f $f -c
done
$LUATOOL $@ -f init.lua -r