#!/bin/bash

jar_no=`ps -ef | grep java | grep Xloggc | grep -v grep | wc -l`
init_no=1
ps -ef | grep java | grep Xloggc | grep -v grep > /app/zabbix/scripts/server.log
NUX=`cat /app/zabbix/scripts/server.log | wc -l`
printf '{"data":[\n'
while(($init_no<=$NUX))
do
    service=`sed -n $init_no'p' /app/zabbix/scripts/server.log`
    JMX_PORT=`echo $service | awk '{for(i=1;i<=NF;++i) print $i }'|grep Dcom.sun.management.jmxremote.port | awk -F'=' '{print $2}'`
    SERVER_NAME=`echo $service | awk '{for(i=1;i<=NF;++i) print $i }'|grep Xloggc | awk -F'/' '{print $NF}'| awk -F'_' '{print $1}'`
    GC_LOG=`echo $service | awk '{for(i=1;i<=NF;++i) print $i }'|grep Xloggc | awk -F':' '{print $2}'`
    if [ $init_no -ne $jar_no ]
        then
           printf "\n\t\t{"
           printf "\"{#JMX_PORT}\":${JMX_PORT},\n"
           printf "\t\t\"{#GC_LOG}\":${GC_LOG},\n"
          # printf "\n\t\t{"
           printf "\t\t\"{#JAVA_NAME}\":\"${SERVER_NAME}\"},"
        else
           printf "\n\t\t{"
           printf "\"{#JMX_PORT}\":${JMX_PORT},\n"
           printf "\t\t\"{#GC_LOG}\":${GC_LOG},\n"
          # printf "\n\t\t{"
           printf "\t\t\"{#JAVA_NAME}\":\"${SERVER_NAME}\"}"
        printf "\n\t]\n"
    printf "}\n"
        fi
        let "init_no=init_no+1"
done
