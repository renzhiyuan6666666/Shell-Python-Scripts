#!/bin/bash
cd /app/kafka/lag
Log_Now=`ls -lrt *.log|tail -n1|awk '{print $9}'`
Topic=$1
Option=$2
case $Option in
lag)
cat $Log_Now|grep "$Topic"|awk '{print $1}'|tail -n1
;;
esac
