#!/bin/bash
if [[ $# != 1 &&  -f $1 ]]; then
    echo "usage: $0 dir"
    exit -1
fi
access_key=
secret_key=
bucket=
domain=
BASE_DIR=
REFRESH_FILE=$BASE_DIR/refresh_url.txt
>$REFRESH_FILE
qshell_linux_amd64 account $access_key $secret_key

uploadFile() {
	if  [[ $# = 1 ]]; then
		if [[ -f $1 ]]; then
			file=$1
			extension=${file##*.} 
			if [[ $extension = "mp3" || $extension = "jpg" ]; then
				mime_type=`file --mime-type -b $1`
				filename=`echo ${file##*/}`
				echo "$filename ::: $mime_type ::: $extension"
				qshell_linux_amd64 fput $bucket $filename $1 true $mime_type
	      echo "$domain$file" >>$REFRESH_FILE
			else
				echo "$file 's extension not support to upload......."
			fi
		elif [[ -d $1 ]]; then
			for file in `ls $1`
			do
				uploadFile $1/$file
			done
		fi
	fi
}

uploadFile $1
qshell_linux_amd64 batchrefresh $REFRESH_FILE 
