#!/bin/bash
RIGCTL="rigctl -m 231 -r /dev/ttyUSB0 -s 9600 -C data_bits=8 -C stop_bits=1 -C serial_handshake=Hardware -C timeout=500.0 -C retry=3.0 -C write_delay=20.0 V VFOA "
function record {
MM=$(date "+%M")

time=`date -u +%g%m%d_%H%M`
freq=`${RIGCTL} f`
tempname=raw/"$freq"_"$time".temp
wavname=raw/"$freq"_"$time".wav

arecord -V mono -D plughw:1,0 -d 112 -f S16_LE -r 12000 -t wav $tempname
aresult=$?

if [ $aresult -gt 0 ];then
	echo Arecord Failed!
	rm $tempname
else
	echo Analyzing...
	mv $tempname $wavname
	./analyzer.sh &
fi
}




while true; do
	#start at even minute
	MM=$(date "+%M")
	SS=$(date "+%S")
	date
	SUM=$(echo "(1- $MM % 2) * 60 + 60-$SS"|bc)
	echo noch $SUM sec warten.

	sleep $SUM
	./coord_hopper.sh
	record
done


