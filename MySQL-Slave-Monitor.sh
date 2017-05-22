#!/bin/bash
#这是一件监控mysql主从是否正常同步的shell
#作者：任志远  邮件：renzhiyuan666666@qq.com
#mysqldir=/usr/local/mysql/
#mysqldata=/usr/local/mysql/data
#mysqllog=/usr/local/mysql/log
mysqlslaveerrorlog=/var/lib/mysql/log/mysql/slave_error.log
mysqluser=用户名
mysqlpasswd=密码
mysqlhost=ip
maillist=renzhiyuan666666@vip.qq.com

Seconds_Behind_Master=`mysql -h${mysqlhost} -u${mysqluser} -p${mysqlpasswd} -e "show slave status \G"|awk -F':' '/Seconds_Behind_Master/{print $2}'`
if [ ${Seconds_Behind_Master} != "NULL" ]
then echo "slave is ok"
else
mysql mysql -h${mysqlhost} -u${mysqluser} -p${mysqlpasswd} -e "show slave status \G"|awk -F':' '/Seconds_Behind_Master/{print $2}' >$mysqlslaveerrorlog
mail -s "xxx服务器数据库不能同步了" $maillist <$mysqlslaveerrorlog
fi

