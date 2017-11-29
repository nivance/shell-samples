#/bin/bash
if [[ $# != 1 ]]; then
    echo "usage: $0 warfile"
    exit -1
fi
if [ ! -f "$1" ]; then
    echo "$1 not exist"  
    exit -1
fi

kill -9 $(ps -ef|grep tomcat | awk '{print $2}' |awk '{if(NR==1) print $1}')
if [ $? -eq 0 ]; then  # 执行上一个指令的返回值 (显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误)
    echo "kill tomcat success"
    rm -rf ./webapps/everobo*
    mv $1 ./webapps
    cd bin/
    ./startup.sh
else
    echo "kill tomcat failed"
    exit -1
fi
