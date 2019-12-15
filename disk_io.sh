#!/bin/bash
Disk=$1
Option=$2
case $Option in
rrqm)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $2}'
;;
wrqm)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $3}'
;;
rps)
iostat -dxk 1 2|grep "\b$Disk\b"|tail -1|awk '{print $4}'
;;
wps)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $5}'
;;
rKBps)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $6}'
;;
wKBps)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $7}'
;;
avgrq-sz)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $8}'
;;
avgqu-sz)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $9}'
;;
await)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $10}'
;;
svctm)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $11}'
;;
util)
iostat -dxk 1 2|grep "\b$Disk\b" |tail -1|awk '{print $12}'
;;
esac
