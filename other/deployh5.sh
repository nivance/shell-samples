#!/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 tag_name"
    exit -1
fi

base_repo=http://*:*@192.168.1.1:9090/git/everobo_h5/hybridH5.git
project_path=/root/deploy/server4/hybridH5

pushFile(){
    if [ -d $project_path ]; then
			for file in `ls $project_path`
			do
				ansible server4 -m copy -a "src=$project_path/$file dest=$1/ owner=root group=root"
			done
		else
			echo "error. $project_path is not dir"
		fi
}

if [ ! -d "$project_path" ]; then
	git clone $base_repo
fi
cd $project_path
git fetch
git checkout -b $1 $1
echo ""
echo '可选择现有部署的位置:'
echo ""
echo '-3q--->>>/usr/share/nginx/prod/3q--->>>https://**.***.com/3q/'
echo '-yhk--->>>/usr/share/nginx/prod/read--->>>https://**.***.com/read/'
echo ""
read -p "Please input 3q or yhk, 或者其它: "
echo ""
case "$REPLY" in 
	3q)
		echo ""
		echo "starting copy files to server, please be patient and do not quit......."
		echo ""
		pushFile "/usr/share/nginx/prod/3q"
		echo "done"
	;;
	yhk)
		echo ""
    echo "starting copy files to server, please be patient and do not quit......."
		echo ""
    pushFile "/usr/share/nginx/prod/read"
    echo "done"
	;;
	*)
		path=$REPLY
		read -p "$REPLY is 新项目? y or no: "
		echo ""
		if [[ "$REPLY" -ne "y" ]] && [[ "$REPLY" -ne "yes" ]]; then
			echo "error input, bye!"
			exit -1
		fi
		echo ""
    echo "starting copy files to server, please be patient and do not quit......."
    echo ""
    pushFile "/usr/share/nginx/prod/$path"
		result_code=`curl -I -m 10 -o /dev/null -s -w %{http_code} https://**.***.com/$path/index.html`
		echo "ping https://**.***.com/$path/index.html return:::$result_code"
		echo ""
		if [ $result_code -ne "200" ]; then
			echo "new project to config nginx"
			ansible server4 -m lineinfile -a "dest=/etc/nginx/conf.d/m.everobo.com.conf regexp='}$' line="" state=present"
			ansible server4 -m lineinfile -a "dest=/etc/nginx/conf.d/m.everobo.com.conf line='    location /$path {'"
			ansible server4 -m lineinfile -a "dest=/etc/nginx/conf.d/m.everobo.com.conf line='        root   /usr/share/nginx/prod/;'"
			ansible server4 -m lineinfile -a "dest=/etc/nginx/conf.d/m.everobo.com.conf line='	  index  index.html index.htm;'"
			ansible server4 -m lineinfile -a "dest=/etc/nginx/conf.d/m.everobo.com.conf line='    }\n}'"
			ansible server4 -a "nginx -s reload"
		fi
    echo "done"		
	;;
esac
