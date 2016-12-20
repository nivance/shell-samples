#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 file"
    exit -1
fi
access_key=
secret_key=
domain=
BASE_DIR=
REFRESH_FILE=$BASE_DIR/refresh_url.txt
>$REFRESH_FILE
/home/dev/qiniu/qshell_linux_amd64 account $access_key $secret_key
cat $1 | while read name
do 
	$BASE_DIR/qiniu/qshell_linux_amd64 delete huiben $name	
	echo "$domain$name" >> $REFRESH_FILE
done
/home/dev/qiniu/qshell_linux_amd64 batchrefresh $REFRESH_FILE 
