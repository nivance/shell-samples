#!/bin/bash
# check arguments
if [[ $# != 1 ]]; then
    echo "usage: $0 dir"
    exit -1
fi
if [[ -d "$1" ]]; then
	for f in `ls $1`
	do
		if [[ ! -d "$f" ]]; then
			fileinfo=$(echo `file -i $1/$f`)
			if [[ $fileinfo =~ "utf-8" ]]; then
				echo "$1/$f is uft-8!"
			else 
				`enconv -L zh_CN -x utf-8 $1/$f`
				echo "$f  to utf-8"
			fi
		fi
	done
else
	echo "$1 is not folder"
	exit -1
fi
