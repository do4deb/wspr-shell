#!/bin/bash
#Minute Band
#00 160
#02 80
#04 60
#06 40
#08 30
#10 20
#12 17
#14 15
#16 12
#18 10
#Frequencies
#160m 1.8366
# "10m" ) F=281246 ;;
# "12m" ) F=249246 ;;
# "15m" ) F=210946 ;;
# "17m" ) F=181046 ;;
# "20m" ) F=140956 ;;
# "30m" ) F=101387 ;;
# "40m" ) F=70386 ;;
# "80m" ) F=35926 ;;

RIGCTL="rigctl -m 231 -r /dev/ttyUSB0 -s 9600 -C data_bits=8 -C stop_bits=1 -C serial_handshake=Hardware -C timeout=500.0 -C retry=3.0 -C write_delay=20.0 V VFOA "

declare hops
declare activeb
declare freqs

hops=(160 80 60 40 30 20 17 15 12 10)
activeb=(false true false true true true false false false false)
freqs=(1836600 3592600 5287200 7038600 10138700 14095600 18104600 21094600 24924600 28124600)

function random_hop {

sel_ind=$( jot -r 1 0 $((${#hops[@]} - 1)) )

if ${activeb[$sel_ind]} ;then
	echo "Switching to ${hops[$sel_ind]} ${freqs[$sel_ind]}"
	${RIGCTL} F ${freqs[$sel_ind]}
else
	random_hop
fi
}



function coord_hop {
MM=$(date "+%M")

F_160=${freqs[0]}
F_80=${freqs[1]}
F_60=${freqs[2]}
F_40=${freqs[3]}
F_30=${freqs[4]}
F_20=${freqs[5]}
F_17=${freqs[6]}
F_15=${freqs[7]}
F_12=${freqs[8]}
F_10=${freqs[9]}

A_160=${activeb[0]}
A_80=${activeb[1]}
A_60=${activeb[2]}
A_40=${activeb[3]}
A_30=${activeb[4]}
A_20=${activeb[5]}
A_17=${activeb[6]}
A_15=${activeb[7]}
A_12=${activeb[8]}
A_10=${activeb[9]}

case $MM in

	59|00|19|20|39|40)
	if $A_160 ;then
		echo "Hopping 160m"
		${RIGCTL} F $F_160
	else
		echo "Time for 160m but not activated -> random"
		random_hop
	fi
	;;

	01|02|21|22|41|42)
	if $A_80 ;then
		echo "Hopping 80m"
		${RIGCTL} F $F_80
	else
		echo "Time for 80m but not activated -> random"
		random_hop
	fi
	;;

	03|04|23|24|43|44)
	if $A_60 ;then
		echo "Hopping 60m"
		${RIGCTL} F $F_60
	else
		echo "Time for 60m but not activated -> random"
		random_hop
	fi
	;;

	05|06|25|26|45|46)
	if $A_40 ;then
		echo "Hopping 40m"
		${RIGCTL} F $F_40
	else
		echo "Time for 40m but not activated -> random"
		random_hop
	fi
	;;

	07|08|27|28|47|48)
	if $A_30 ;then
		echo "Hopping 30m"
		${RIGCTL} F $F_30
	else
		echo "Time for 30m but not activated -> random"
		random_hop
	fi
	;;

	09|10|29|30|49|50)
	if $A_20 ;then
		echo "Hopping 20m"
		${RIGCTL} F $F_20
	else
		echo "Time for 20m but not activated -> random"
		random_hop
	fi
	;;

	11|12|31|32|51|52)
	if $A_17 ;then
		echo "Hopping 17m"
		${RIGCTL} F $F_17
	else
		echo "Time for 17m but not activated -> random"
		random_hop
	fi 
	;;

	13|14|33|34|53|54)
	if $A_15 ;then
		echo "Hopping 15m"
		${RIGCTL} F $F_15
	else
		echo "Time for 15m but not activated -> random"
		random_hop
	fi
	;;

	15|16|35|36|55|56)
	if $A_12 ;then
		echo "Hopping 12m"
		${RIGCTL} F $F_12
	else 
		echo "Time for 12m but not activated -> random"
		random_hop
	fi
	;;

	17|18|37|38|57|58)
	if $A_10 ;then
		echo "Hopping 10m"
		${RIGCTL} F $F_10
	else
		echo "Time for 10m but not activated -> random"
		random_hop
	fi
	;;

	*)
	echo "Undefined: Hopping 40m"
	${RIGCTL} F $F_40
	;;

esac

}

coord_hop
