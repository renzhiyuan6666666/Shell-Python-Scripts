# !/usr/local/bin/python
# -*- coding:utf-8 -*-
import httplib
import urllib
import sys
from logging.handlers import RotatingFileHandler
import logging
import os

#打电话
def send_call(host):
    logging1 = logger("logs/call.logs", "autocall")
    print logging1

    try:
        host = "11.111.7.34"
        call_send_uri = "/Service.asmx/SendVoiceForCode?"
        #phone = open("p.txt","r").read()#通过文件传电话
        #phone=sys.argv[1]#执行时传参python filename.py number
        phone = '18810741404'#直接传电话号码

        #http请求，
        #请求的链接是http://service.winic.org:8813/Service.asmx/SendVoiceForCode?userName=帐号&PassWord=密码&Mobile=被叫号码&Code=验证码&DisPlayNbr=主叫号码&vReplay=是否重听
        #下面代码就是拼这个链接
        params = urllib.urlencode(
                {'userName': "wangxuedeo", 'PassWord': "wangxue1992", 'Mobile': "%s"%phone, 'Code': "6 6 6", 'DisPlayNbr': "",
                    'vReplay': "2"})
        headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
        conn = httplib.HTTPConnection(host, port=10070, timeout=30)
        conn.request("POST", call_send_uri, params, headers)
        response = conn.getresponse()
        response_str = response.read()
        conn.close()
        logging1.info("{ringup success mobile: " + phone +"}")#成功写日志
        return response_str
    except Exception as e :
        print e
        logging1.error("{ringup failed mobile: " + phone + "}")
        pass


#写日志
def logger(path,name):
    LOG_FILE = path
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    fh = RotatingFileHandler(LOG_FILE, maxBytes=1024*1024*5, backupCount=5)
    datefmt = '%Y-%m-%d %H:%M:%S'
    format_str = '%(asctime)s %(levelname)s %(message)s '
    formatter = logging.Formatter(format_str, datefmt)
    fh.setFormatter(formatter)
    logger.addHandler(fh)
    return logger



if __name__ == '__main__':
    #因为网络开通的不是F5连接，连接的是具体的地址，所以要判断两台msggate网络是否连通
    #网络开的是DMZ——>msggate——>互联网
    host = "11.111.7.34"  # 转发 ip1
#    host2 = "11.111.7.35"  # 转发 ip2
    # 默认连接host1，不通再连host2
#    host=host1
    #exit_code = os.system('ping service.winic.org ')
#    exit_code = os.system('ping %s'%(host1))
#    print exit_code
#    if exit_code :
#        host=host2
#
    print(send_call(host))#打电话

