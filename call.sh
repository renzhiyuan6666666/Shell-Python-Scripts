#!/bin/bash
DATE=`date`
echo "${DATE} ,触发外呼" >>call.log
phpone=$1
outbid=1
while true
do
 outbid=`cat outbid.txt`
 cd /app/zabbix/alertscripts
 echo -e "${phpone} ,${outbid}" >>call.log
 /usr/bin/curl -i -k -H "Content-type: application/json" -X POST -d  '{"outbId":'$outbid',"functionType":1,"aodID":26,"calledNumber":'\"$phpone\"',"businessParam":{"param1":"alarm","p2":"M"}}'  http://11.111.16.35:9992/requestOutbound >callresponse.txt
 cat callresponse.txt >>call.log 
 let outbid++
 echo $outbid > outbid.txt
 status=`grep status callresponse.txt |awk  -F '\"' '{print $4}'`
 if [ $status == 0 ]; then
  echo -e "\n${DATE} ,呼叫成功,状态码:$status\n" >>call.log
  break
 else
  echo -e "\n${DATE} ,呼叫失败,状态码:$status\n" >>call.log
  sleep 30
 fi
done	
