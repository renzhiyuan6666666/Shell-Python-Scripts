#!/bin/bash
Today_Time=`date  +%Y-%m-%d-%H-%M`
IP_LIST="11.111.6.19:9092,11.111.6.20:9092,11.111.6.21:9092"
cd /app/kafka 
#lag log output
group_list=`./bin/kafka-consumer-groups.sh --bootstrap-server $IP_LIST --list`
for group in $group_list; do
    group_info=`./bin/kafka-consumer-groups.sh --bootstrap-server  $IP_LIST  --group ${group} --describe >> lag/$group-$Today_Time.txt`
         awk '{print $5,$1,$6}' lag/$group-$Today_Time.txt |grep consumer|awk '{print $1,$2}'|grep -v "^-"|sort -nr|uniq|head -n9 >>lag/$group-lagtop5-$Today_Time.txt
        cat lag/*lagtop5-$Today_Time.txt >>lag/lagtop5-$Today_Time.log
	rm lag/*.txt  && find lag/ -name *.log -type f -mtime +1|xargs -i mv {} lag/lag-history
done 

