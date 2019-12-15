#!/bin/bash
Today_time=`date +%Y-%m-%d-%H-%M`
#Cluster
IP_Cluster1="11.111.64.39:2181,11.111.64.40:2181,11.111.64.41:2181"
IP_Cluster2="11.111.64.39:2181,11.111.64.40:2181,11.111.64.41:2181"
echo -e "\033[42;37m 当前脚本支持的Broker集群列表1-旧运维区kafka集群使用：$IP_Cluster1 \033[0m"
echo -e "\033[42;37m 当前脚本支持的Broker集群列表2-新运维区kafka集群使用：$IP_Cluster2 \033[0m"
echo "-----------------------------------------------------------------------------------------------"

#Partition_Number_IP_Cluster1
Partition_Number_IP_Cluster1_3_3="0:1:2,1:2:0,2:0:1"
Partition_Number_IP_Cluster1_6_3="0:1:2,1:2:0,2:0:1,0:1:2,1:2:0,2:0:1"
Partition_Number_IP_Cluster1_9_3="0:1:2,1:2:0,2:0:1,0:1:2,1:2:0,2:0:1,0:1:2,1:2:0,2:0:1"
Partition_Number_IP_Cluster1_9_2="0:1,1:2,2:0,0:1,1:2,2:0,0:1,1:2,2:0"
echo -e "\033[42;37m 集群列表1当前脚本支持分布分区数3,副本数3：$Partition_Number_IP_Cluster1_3_3 \033[0m"
echo -e "\033[42;37m 集群列表1当前脚本支持分布分区数6,副本数3：$Partition_Number_IP_Cluster1_6_3 \033[0m"
echo -e "\033[42;37m 集群列表1当前脚本支持分布分区数9,副本数3：$Partition_Number_IP_Cluster1_9_3 \033[0m"
echo -e "\033[42;37m 集群列表1当前脚本支持分布分区数9,副本数2：$Partition_Number_IP_Cluster1_9_2 \033[0m"
echo "-----------------------------------------------------------------------------------------------"

#Partition_Number_IP_Cluster2
Partition_Number_IP_Cluster2_3_3="3:4:5,4:5:3,5:3:4"
Partition_Number_IP_Cluster2_6_3="3:4:5,4:5:3,5:3:4,3:4:5,4:5:3,5:3:4"
Partition_Number_IP_Cluster2_9_3="3:4:5,4:5:3,5:3:4,3:4:5,4:5:3,5:3:4,3:4:5,4:5:3,5:3:4"
Partition_Number_IP_Cluster2_9_2="3:4,4:5,5:3,3:4,4:5,5:3,3:4,4:5,5:3"
echo -e "\033[42;37m 集群列表2当前脚本支持分布分区数3,副本数3：$Partition_Number_IP_Cluster2_3_3 \033[0m"
echo -e "\033[42;37m 集群列表2当前脚本支持分布分区数6,副本数3：$Partition_Number_IP_Cluster2_6_3 \033[0m"
echo -e "\033[42;37m 集群列表2当前脚本支持分布分区数9,副本数3：$Partition_Number_IP_Cluster2_9_3 \033[0m"
echo -e "\033[42;37m 集群列表2当前脚本支持分布分区数9,副本数2：$Partition_Number_IP_Cluster2_9_2 \033[0m"
echo "-----------------------------------------------------------------------------------------------"

#Zookeeper_List Topic_Name Partition_Factor_Number 
read -p "请输入你所要创建的Broker集群列表:" Zookeeper_List
read -p "请输入你所要创建的Topic名字:" Topic_Name
read -p "请输入你所要创建的Partition和Factor分布:" Partition_Factor_Number
echo "-----------------------------------------------------------------------------------------------"

#create topic
if [ `echo $Partition_Factor_Number|awk -F: '{print $1}'` -lt 3 ]
then 
echo $Today_time >>topic-create-$Today_time.txt
echo -e "准备创建的命令如下，请再次复核后操作:\n/app/kafka/bin/kafka-topics.sh --create --zookeeper $Zookeeper_List --topic $Topic_Name --replica-assignment $Partition_Factor_Number" >>topic-create-$Today_time.txt
echo -e "\033[42;37m 准备创建的命令如下，请再次复核后操作:\n/app/kafka/bin/kafka-topics.sh --create --zookeeper $Zookeeper_List --topic $Topic_Name --replica-assignment $Partition_Factor_Number \033[0m"
elif [ `echo $Partition_Factor_Number|awk -F: '{print $1}'` -ge 3 ]
then
echo $Today_time >>topic-create-$Today_time.txt
echo -e "准备创建的命令如下，请再次复核后操作:\n/app/kafka/bin/kafka-topics.sh --create --zookeeper $Zookeeper_List --topic $Topic_Name --replica-assignment $Partition_Factor_Number" >>topic-create-$Today_time.txt
echo -e "\033[41;37m 准备创建的命令如下，请再次复核后操作:\n/app/kafka/bin/kafka-topics.sh --create --zookeeper $Zookeeper_List --topic $Topic_Name --replica-assignment $Partition_Factor_Number \033[0m"
else
echo -e "\033[41;37m 请输入正确的$Partition_Factor_Number \033[0m"
fi

