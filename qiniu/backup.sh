#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 file"
    exit -1
fi
access_key=
secret_key=
domain=
bucket=
BASE_DIR=
LIST_BUCKET_DIR=
BACKUP_DIR=
qshell_linux_amd64 account $access_key $secret_key
cat $1 | while read info
do 
	echo "$info"
	name=`echo $info | cut -d ' ' -f 1`
	id=`echo $info | cut -d ' ' -f 2`
	echo "$name -----$id"
	destDir=$BACKUP_DIR/$name
	mkdir -p $destDir
	if [ -n "$id" ]; then
		echo "id:::$id is not empty"
		confFile=$BACKUP_DIR/$name/$id.conf
		echo "{\"dest_dir\":\"$destDir\",\"bucket\":\"$bucket\",\"domain\":\"$domain\",\"access_key\":\"$access_key\",\"secret_key\":\"$secret_key\",\"prefix\":\"$bookid\"}" > $confFile
		qshell_linux_amd64 qdownload 5 $confFile
	fi
	confFile=$BACKUP_DIR/$bookname/$bookname.conf
        echo "{\"dest_dir\":\"$destDir\",\"bucket\":\"$bucket\",\"domain\":\"$domain\",\"access_key\":\"$access_key\",\"secret_key\":\"$secret_key\",\"prefix\":\"$name\"}" > $confFile
	qshell_linux_amd64 qdownload 2 $confFile
done
rm -f *.list.txt
