#!/bin/bash
processdir=~/scripts/wspr/processed

if [ -f wsprd.out ];then
	rm wsprd.out
fi

time=`date -u +%g%m%d_%H%M`


for f in `ls raw/*.wav`;do 
	base=`basename $f`
	file="${base%.*}"
	freq=`echo $base | cut -d "_" -f 1`
	ctime=`echo $file | cut -d "_" -f 3`
	wfreq=`bc -l <<< "$freq/1000000"`
	outfile=$processdir/"$file".out

	echo Processing $base on $wfreq
	./k9an-wsprd -n -w -f $wfreq $f >> k9an-wsprd.log

	mv $f $processdir
	./spectro.sh $processdir/$base &
	
	if [ -f wsprd.out ];then
		cat wsprd.out >> $outfile
	fi
done

if [ -s $outfile ];then
	echo Result:
	cat $outfile
	echo uploading.....
	#read upload
	ans=`curl -s --connect-timeout 10 \
   	 --max-time 30 \
	 --retry 5 \
	 --retry-delay 0 \
	 --retry-max-time 90 \
	 -F allmept=@$outfile -F call=do4deb -F grid=jo43ja http://wsprnet.org/meptspots.php`
	adds=`echo $ans | grep -Eo "[0-9]+ out of [0-9]+"`
	echo $adds Spots added.
	else
	echo "Keine Spots"
fi
