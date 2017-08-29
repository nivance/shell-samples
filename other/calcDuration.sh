#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 dir"
    exit -1
fi
SQL_FILE=./$1/update_audio.sql
>$SQL_FILE
for file in `ls $1`
do 
	if [[ $file =~ .*\.etcb ]]; then
		#echo $file
		ns=(${file//./})
		name=${ns[0]}
		echo $name
		sum=0
		for i in {1..100}
		do
			lengthTime=`cat $1/$file | jq ".pageInfo[$i].lengthTime"`
			if [ "$lengthTime" == "null" ]; then
				break	
			else 
				minute=${lengthTime:1:2}
				second=${lengthTime:4:2}
				sum=`expr $sum + 60 \* $minute + $second`
				#echo "${lengthTime:1:5}----$minute----$second---"
			fi
		done
		echo "$file's length : $sum"
		echo "update t_audio set DURATION = $sum where NAME = '$name' AND STATUS = 1 AND AUTHENTICATE = 1;" >> $SQL_FILE
	fi
done
