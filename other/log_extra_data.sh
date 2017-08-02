#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 dir"
    exit -1
fi
for file in `ls $1`
do
	if [[ $file =~ catalina.2017-07.*out ]]; then
		echo $file	
		day=${file:9:10}
		echo $1/read_data_$day.log
		grep 'uploadreaddata.*RESP_COST.*code\"\:\"0000' $1/$file | awk '{last=index($12, "],");print substr($12, 10, last-10) > "'$1/read_data_$day.log'"}'	
	fi
done