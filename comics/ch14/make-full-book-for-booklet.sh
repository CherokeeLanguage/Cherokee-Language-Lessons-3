#!/bin/bash

cd "$(dirname "$0")" || exit 1

for x in *.lyx; do
	y="$(echo "$x"|sed 's/.lyx/.pdf/')"
	if [ ! -f "$y" ]; then continue; fi
	pdfbook --letterpaper --suffix 'booklet-duplex-long' "$y"
done
