#!/bin/bash

SOX=~/sources/sox-14.4.2/src/sox
processdir=~/scripts/wspr/processed

input=$1
base=`basename $input`
file="${base%.*}"
freq=`echo $base | cut -d "_" -f 1`
ctime=`echo $file | cut -d "_" -f 3`
ctime=${ctime:0:2}:${ctime:2:2}
ctime="$ctime UTC"
wfreq=`bc -l <<< "$freq/1000000"`
band=`bc -l <<< "300/$wfreq" | cut -d "." -f 1`
wshort=`echo "$wfreq" | cut -d "." -f 1`
wshort="$wshort MHz"
#4050−3886 164
#210-164
i=1

while read -r line;do
sn[$i]=`echo $line | cut -d " " -f 4`
rfreq=`echo $line | cut -d " " -f 6`
call[$i]=`echo $line | cut -d " " -f 7`

rfreq=${rfreq:4}
#pxl[$i]=`bc -l <<< "200-($rfreq-4015)"` #80m

#14.095600 14.097048
#pxl[$i]=`bc -l <<< "(200 - ($rfreq-7000))"` #40m
pxl[$i]=$((210-$i*20))

#echo ${pxl[$i]}
#echo ${call[$i]}
i=$(($i+1))
done < $processdir/$file.out

#echo $wfreq
${SOX} 	$input -r4k -n rate highpass -2 1500 500h \
	spectrogram -X 1 -Y2050 -z50 -r -o - | \
	convert - -crop 115x210+0+400 +repage -font /usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-R.ttf \
			-gravity SouthEast -pointsize 12 -fill white -draw "text 0,0 '$ctime'" \
			-gravity NorthEast -pointsize 12 -fill white -draw "text 0,0 '$wshort'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[1]} '${call[1]} ${sn[1]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[2]} '${call[2]} ${sn[2]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[3]} '${call[3]} ${sn[3]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[4]} '${call[4]} ${sn[4]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[5]} '${call[5]} ${sn[5]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[6]} '${call[6]} ${sn[6]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[7]} '${call[7]} ${sn[7]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[8]} '${call[8]} ${sn[8]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[9]} '${call[9]} ${sn[9]}'" \
			-gravity NorthWest -pointsize 10 -fill white -draw "text 0,${pxl[10]} '${call[10]} ${sn[10]}'" \
				$processdir/$file.png

#~/sources/sox-14.4.2/src/sox 3592600_150412_0050.wav -r4k -n rate highpass -2 1500 500h spectrogram -X 1 -Y2050 -z50 -r -o - | convert - -crop 115x210+0+450 +repage - | feh -
#~/sources/sox-14.4.2/src/sox 3592600_150412_0050.wav -r4k -n rate highpass -2 1500 500h spectrogram -X 1 -Y2050 -z50 -o - | convert - -crop 201x210+173+450 +repage ../scale_r.png
# ~/sources/sox-14.4.2/src/sox 3592600_150412_0050.wav -r4k -n rate highpass -2 1500 500h spectrogram -X 1 -Y2050 -z50 -o - | convert - -crop 58x210+0+450 +repage ../scale_l.png

last_slices=($(ls -t $processdir/*.png | head -n 10))

#echo ${array[@]}
killall feh
montage scale_l.png ${last_slices[@]} scale_r.png -tile x1 -geometry +0+0 - | feh -
