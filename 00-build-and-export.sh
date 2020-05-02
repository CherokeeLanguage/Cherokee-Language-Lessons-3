#!/bin/bash

set -e
set -o pipefail

function die(){
	echo "ERROR!"
	echo "$0"
	echo "$1"
	echo "$2"
	echo "$3"
	read a
	exit -1
}
trap die ERR

wrkFile='Cherokee Language Lessons 3'
lyxFile="${wrkFile}.lyx"

cd "$(dirname "$0")" || exit 1
DEST="/home/muksihs/Sync/Cherokee/CherokeeLanguageLessons/Volume-03/MASTER/"
mkdir -p "$DEST"
cp scripts/autosplit-answers.sh "$DEST"

lyx -e pdf4 "$lyxFile" -e pdf4 "$lyxFile"

cp "$wrkFile".pdf "$DEST"
cd "$DEST"

bash autosplit-answers.sh "$wrkFile" || exit 0

cd ..
xdg-open "$(pwd)" &

sleep 1

