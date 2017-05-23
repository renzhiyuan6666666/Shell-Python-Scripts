#!/bin/bash  
#批量ssh认证建立 
for p in $(cat /root/ip.list)  #注意ip.txt文件的绝对路径  
do  
ip=$(echo "$p"|cut -f1 -d":")       #取ip.txt文件中的ip地址  
password=$(echo "$p"|cut -f2 -d":") #取ip.txt文件中的密码  

#expect自动交互开始  
expect -c "   
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$ip  
        expect {   
                \"*yes/no*\" {send \"yes\r\"; exp_continue}   
                \"*password*\" {send \"$password\r\"; exp_continue}   
                \"*Password*\" {send \"$password\r\";}   
        }   
"   
done  

#通过ssh批量执行命令 
for h in $(cat /root/ip.list|cut -f1 -d":")  
do 
ssh root@$h 'ifconfig'   
#如果命令是多行的，请参照下面  
#ssh root@$h '此处写要执行的命令1' 
#ssh root@$h '此处写要执行的命令2' 
#ssh root@$h '此处写要执行的命令3' 
done 


#可参考：
http://www.iyunv.com/thread-4980-1-1.html