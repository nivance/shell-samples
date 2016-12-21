#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 dir"
    exit -1
fi
access_key=
secret_key=
domain=
bucket=
BASE_DIR=
REFRESH_FILE=$BASE_DIR/refresh_url.txt
>$REFRESH_FILE
qshell_linux_amd64 account $access_key $secret_key
for file in `ls $1`
do
	mime_type=`file --mime-type -b $1/$file`
	echo "$1/$file ::: $mime_type"
	qshell_linux_amd64 fput $bucket $file "$1/$file" true $mime_type
	echo "$domain$file" >> $REFRESH_FILE
done
qshell_linux_amd64 batchrefresh $REFRESH_FILE 
