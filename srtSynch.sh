#!/bin/bash

file="NULL"

min=0
sec=0
ms=0
sign=+

while getopts "f:s:m:S:M:" flag
do
    
    if [[ "$flag" == "f" ]]
    then
	if $(test -f $OPTARG)
	then
	    echo -e "File read. Processing now\n"
	    file=$OPTARG
	    touch $file.tmp
	    tmpFile=$file.tmp
	else
	    echo -e "File not found!\n"
	fi
    fi
    
    if [[ "$flag" == "s" ]]
    then
	if [[ "$OPTARG" == "+" ]]
	then
	    sign=+
	elif [[ "$OPTARG" == "-" ]]
	then
	    sign=-
	else
	    echo "invalid sign"
	    exit
	fi
    fi
    if [[ "$flag" == "m" ]]
    then
	min=$OPTARG
    fi
    if [[ "$flag" == "S" ]]
    then
	sec=$OPTARG
    fi
    if [[ "$flag" == "M" ]]
    then
	ms=$OPTARG
    fi
done

echo -e "MIN: $min\tSEC: $sec\tMS: $ms\n"

if [[ $file == "NULL" ]]
then
  echo "file not specified!"
  exit
fi

while read line
do
    if [[ "$line" =~ ^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}\ ?--\>\ ?[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}$ ]]
    then
	tmpLine=$( echo "$line" | sed 's/ --> /:/g;s/,/:/g' )

	arrIN=(${tmpLine//:/ })

	arrIN[3]=$(expr ${arrIN[3]} $sign $ms)

	if [ ${arrIN[3]} -lt 0 ]
	then
	    arrIN[3]=$(expr ${arrIN[3]} + 1000)
	    arrIN[2]=$(expr ${arrIN[2]} - 1)

	    if [ ${arrIN[2]} -lt 0 ]
	    then
		arrIN[2]=$(expr ${arrIN[2]} + 60)
		arrIN[1]=$(expr ${arrIN[1]} - 1)

		if [ ${arrIN[1]} -lt 0 ]
		then
		    arrIN[1]=$(expr ${arrIN[1]} + 60)
		    arrIN[0]=$(expr ${arrIN[0]} - 1)
		fi
	    fi
	fi

	if [ ${arrIN[3]} -ge 1000 ]
	then
	    arrIN[3]=$(expr ${arrIN[3]} - 1000)
	    arrIN[2]=$(expr ${arrIN[2]} + 1)

	    if [ ${arrIN[2]} -ge 60 ]
	    then
		arrIN[2]=$(expr ${arrIN[2]} - 60)
		arrIN[1]=$(expr ${arrIN[1]} + 1)

		if [ ${arrIN[1]} -ge 60 ]
		then
		    arrIN[1]=$(expr ${arrIN[1]} - 60)
		    arrIN[0]=$(expr ${arrIN[0]} + 1)
		fi
	    fi
	fi
	
	arrIN[7]=$(expr ${arrIN[7]} $sign $ms)
		
	if [ ${arrIN[7]} -ge 1000 ]
	then
	    arrIN[7]=$(expr ${arrIN[7]} - 1000)
	    arrIN[6]=$(expr ${arrIN[6]} + 1)
	    
	    if [ ${arrIN[6]} -ge 60 ]
	    then
		arrIN[6]=$(expr ${arrIN[6]} - 60)
		arrIN[5]=$(expr ${arrIN[5]} + 1)

		if [ ${arrIN[5]} -ge 60 ]
		then
		    arrIN[5]=$(expr ${arrIN[5]} - 60)
		    arrIN[4]=$(expr ${arrIN[4]} + 1)
		fi
	    fi   
	fi

	if [ ${arrIN[7]} -lt 0 ]
	then
	    arrIN[7]=$(expr ${arrIN[7]} + 1000)
	    arrIN[6]=$(expr ${arrIN[6]} - 1)
	    
	    if [ ${arrIN[6]} -lt 0 ]
	    then
		arrIN[6]=$(expr ${arrIN[6]} + 60)
		arrIN[5]=$(expr ${arrIN[5]} - 1)

		if [ ${arrIN[5]} -lt 0 ]
		then
		    arrIN[5]=$(expr ${arrIN[5]} + 60)
		    arrIN[4]=$(expr ${arrIN[4]} - 1)
		fi
	    fi   
	fi

	arrIN[2]=$(expr ${arrIN[2]} $sign $sec)

	if [ ${arrIN[2]} -ge 60 ]
	then
	    arrIN[2]=$(expr ${arrIN[2]} - 60)
	    arrIN[1]=$(expr ${arrIN[1]} + 1)

	    if [ ${arrIN[1]} -ge 60 ]
	    then
		arrIN[1]=$(expr ${arrIN[1]} - 60)
		arrIN[0]=$(expr ${arrIN[0]} + 1)
	    fi
	fi

	if [ ${arrIN[2]} -lt 0 ]
	then
	    arrIN[2]=$(expr ${arrIN[2]} + 60)
	    arrIN[1]=$(expr ${arrIN[1]} - 1)

	    if [ ${arrIN[1]} -lt 0 ]
	    then
		arrIN[1]=$(expr ${arrIN[1]} + 60)
		arrIN[0]=$(expr ${arrIN[0]} - 1)
	    fi
	fi
	
	arrIN[6]=$(expr ${arrIN[6]} $sign $sec)
		
	if [ ${arrIN[6]} -ge 60 ]
	then
	    arrIN[6]=$(expr ${arrIN[6]} - 60)
	    arrIN[5]=$(expr ${arrIN[5]} + 1)

	    if [ ${arrIN[5]} -ge 60 ]
	    then
		arrIN[5]=$(expr ${arrIN[5]} - 60)
		arrIN[4]=$(expr ${arrIN[4]} + 1)
	    fi
	fi

	if [ ${arrIN[6]} -lt 0 ]
	then
	    arrIN[6]=$(expr ${arrIN[6]} + 60)
	    arrIN[5]=$(expr ${arrIN[5]} - 1)

	    if [ ${arrIN[5]} -lt 0 ]
	    then
		arrIN[5]=$(expr ${arrIN[5]} + 60)
		arrIN[4]=$(expr ${arrIN[4]} - 1)
	    fi
	fi

	arrIN[1]=$(expr ${arrIN[1]} $sign $min)

	if [ ${arrIN[1]} -ge 60 ]
	then
	    arrIN[1]=$(expr ${arrIN[1]} - 60)
	    arrIN[0]=$(expr ${arrIN[0]} + 1)
	fi

	if [ ${arrIN[1]} -lt 0 ]
	then
	    arrIN[1]=$(expr ${arrIN[1]} + 60)
	    arrIN[0]=$(expr ${arrIN[0]} - 1)
	fi

	arrIN[5]=$(expr ${arrIN[5]} $sign $min)
		
	if [ ${arrIN[5]} -ge 60 ]
	then
	    arrIN[5]=$(expr ${arrIN[5]} - 60)
	    arrIN[4]=$(expr ${arrIN[4]} + 1)
	fi

	if [ ${arrIN[5]} -lt 0 ]
	then
	    arrIN[5]=$(expr ${arrIN[5]} + 60)
	    arrIN[4]=$(expr ${arrIN[4]} - 1)
	fi
	
	((tmp=${arrIN[0]}))
	if [ $tmp -lt 10 ] 
	then
	   arrIN[0]="0$tmp"
	fi

	tmp=${arrIN[1]}
	if [ $tmp -lt 10 ] 
	then
	   arrIN[1]="0$tmp"
	fi

	tmp=${arrIN[2]}
	if [ $tmp -lt 10 ] 
	then
	   arrIN[2]="0$tmp"
	fi

	tmp=${arrIN[3]}
	if [ $tmp -lt 100 ] 
	then
	    if [ $tmp -lt 10 ] 
	    then
		arrIN[3]="00$tmp"
	    else
		arrIN[3]="0$tmp"
	    fi
	fi

	((tmp=${arrIN[4]}))
	if [ $tmp -lt 10 ] 
	then
	   arrIN[4]="0$tmp"
	fi

	tmp=${arrIN[5]}
	if [ $tmp -lt 10 ] 
	then
	   arrIN[5]="0$tmp"
	fi

	tmp=${arrIN[6]}
	if [ $tmp -lt 10 ] 
	then
	   arrIN[6]="0$tmp"
	fi

	tmp=${arrIN[7]}
	if [ $tmp -lt 100 ] 
	then
	    if [ $tmp -lt 10 ] 
	    then
		arrIN[7]="00$tmp"
	    else
		arrIN[7]="0$tmp"
	    fi
	fi

	echo "${arrIN[0]}:${arrIN[1]}:${arrIN[2]},${arrIN[3]} --> ${arrIN[4]}:${arrIN[5]}:${arrIN[6]},${arrIN[7]}"
    else
	echo $line
    fi
done < $file > $tmpFile
