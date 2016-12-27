#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 file"
    exit -1
fi
access_key=
secret_key=
bucket=
./qshell_linux_amd64 account $access_key $secret_key
cat $1 | while read info
do 
	echo "$info"
	fromname=`echo $info | cut -d ' ' -f 1`
	toname=`echo $info | cut -d ' ' -f 2`
	./qshell_linux_amd64 move $bucket $fromname $bucket $toname
done
