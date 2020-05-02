#!/bin/sh
PDF="ᎠᏠᏍᎩ-ᏥᏍᏚ-#3"
bksize="1325x2050" #200dpi: 6.625x10.25
hisize="1988x3075" #300dpi: 
pgsize="2650x4100" #400dpi: 6.625x10.25
lyx="ᎠᏠᏍᎩ-ᏥᏍᏚ-#3-complete"

cd "$(dirname "$0")" || exit 1
if [ ! -d panels ]; then mkdir panels; fi
rm panels/*

cp src.panels/[0-9][0-9][0-9].png panels/.

gm convert panels/*.png -filter sinc -compress JPEG -quality 30 -resize "$bksize" "$PDF".pdf
pdfbook --suffix 'duplex-long' "$PDF".pdf

if [ ! -d panels.lyx ]; then mkdir panels.lyx; fi
if [ ! -d panels.hires ]; then mkdir panels.hires; fi
rm panels.lyx/*
rm panels.hires/*

cp src.panels/[0-9][0-9][0-9].png panels.lyx/.

for img in panels.lyx/*.png; do
	img2="$(echo "$img"|sed 's/.png$/.jpg/')"
	gm convert "$img" -resize "50%" -quality 70 "$img2"
	rm "$img"
done

cp src.panels/[0-9][0-9][0-9].png panels.hires/.
for img in panels.hires/*.png; do
	img2="$(echo "$img"|sed 's/.png$/.jpg/')"
	gm convert "$img" -resize "$hisize" -quality 30 "$img2"
	rm "$img"
done

rm "$lyx".pdf
lyx --export pdf4 "$lyx".lyx
pdfbook --suffix 'duplex-long' "$lyx".pdf

exit 0



for img in panels/*.jpg; do
	w=$(gm identify "$img" | cut -f 3 -d ' ' | cut -f 1 -d '+'|cut -f 1 -d 'x')
	h=$(gm identify "$img" | cut -f 3 -d ' ' | cut -f 1 -d '+'|cut -f 2 -d 'x')
	nw=$(($w*11/10))
	nh=$(($h*11/10))
	echo "$w:$nw x $h:$nh"
	gm mogrify -gravity center -background white -extent "$nw"x"$nh" -quality 20 "$img"
done

if [ ! -d panels.lyx ]; then mkdir panels.lyx; fi
rm panels.lyx/*

cp src.panels/*.jpg panels.lyx/.

for img in panels.lyx/*.jpg; do
	gm mogrify -resize "50%" -quality 70 "$img"
done

gm convert panels.lyx/*.jpg -filter sinc -compress JPEG -quality 30 "$PDF"-ereader.pdf

gm convert panels/*.jpg -filter sinc -compress JPEG -quality 30 tmp.pdf
pdfnup --nup 3x2 --suffix '3x2' tmp.pdf
mv tmp-3x2.pdf "$PDF"-3x2.pdf

pdfnup --no-landscape --nup 1x2 --suffix '1x2' tmp.pdf
pdfbook --short-edge --suffix 'booklet-duplex-short' tmp-1x2.pdf
pdfbook --suffix 'booklet-duplex-long' tmp-1x2.pdf

mv "tmp-1x2-booklet-duplex-long.pdf" "$PDF"-duplex-normal.pdf
mv "tmp-1x2-booklet-duplex-short.pdf" "$PDF"-duplex-short.pdf

rm tmp.pdf
rm tmp-1x2.pdf

