#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 dir"
    exit -1
fi
for file in `ls $1`
do 
	if [[ $file =~ .*\.etcb ]]; then
		#echo $file
		ns=(${file//\./ })
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
			fi
		done
		echo "$file's length : $sum"
	fi
done
