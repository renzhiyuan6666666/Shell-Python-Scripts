#!/bin/bash
cd /app/kafka/lag/
Log_Now=`ls -lrt *.log|tail -n1|awk '{print $9}'`
Topic_Name=(`cat $Log_Now|awk '{print $1,$2}'|sort -nr|awk '{print $2}'|head -n40|uniq 2>/dev/null`)
length=${#Topic_Name[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
        printf '\n\t\t{'
        printf "\"{#TOPIC_NAME}\":\"${Topic_Name[$i]}\"}"
        if [ $i -lt $[$length-1] ];then
                printf ','
        fi
done
printf  "\n\t]\n"
printf "}\n"
