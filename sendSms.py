#!/usr/bin/env python
# coding:utf-8

import xml.dom.minidom
import datetime
import urllib2
import random
import logging
import sys
# from logging.handlers import RotatingFileHandler


def createSmsXml(seqno, mobiles, content):
    # 在内存中创建一个空的文档
    doc = xml.dom.minidom.Document()
    root = createChild(doc, None, "SoapService")

    header = createChild(doc, root, "ServiceHeader")
    createChildWithTxt(doc, header, "SeqNo", seqno)
    createChildWithTxt(doc, header, "ServiceType", "SMS")
    createChildWithTxt(doc, header, "ChannelType", "CHANNEL")
    createChildWithTxt(doc, header, "ClrDate",
                       datetime.datetime.now().strftime('%Y%m%d'))
    createChildWithTxt(doc, header, "ReqTime",
                       datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
    createChildWithTxt(doc, header, "LogId", "5803704")

    body = createChild(doc, root, "ServiceBody")
    smsrq = createChild(doc, body, "SMSRq")

    if mobiles.isdigit():
        item = createChild(doc, smsrq, "Item")
        createChildWithTxt(doc, item, "Tel", mobiles)
        createChildWithTxt(doc, item, "Content", content)
    else:
        for m in mobiles.split(","):
            item = createChild(doc, smsrq, "Item")
            createChildWithTxt(doc, item, "Tel", m)
            createChildWithTxt(doc, item, "Content", content)

    doc.appendChild(root)

    return doc.toxml()


def createChild(doc, parent, tag):
    tagNode = doc.createElement(tag)
    if parent is not None:
        parent.appendChild(tagNode)
    return tagNode


def createChildWithTxt(doc, parent, tag, txt):
    tagNode = createChild(doc, parent, tag)
    tagNode.appendChild(doc.createTextNode(txt))
    return tagNode


def http_post(url, data):

    # f = urllib2.urlopen(url, urllib.urlencode(data))
    f = urllib2.urlopen(url, data)
    return f.read()


def parseXml(data):

    dom = xml.dom.minidom.parseString(data)
    root = dom.documentElement

    result = root.getElementsByTagName("Result")

    for r in result:
        for child in r.childNodes:
            return child.nodeValue


if __name__ == '__main__':

    mobiles = sys.argv[1]
    subject = sys.argv[2]
    message = sys.argv[3]

    # mobiles = "13822142543"
    # subject = "sub-"
    # message = "message"

    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                        datefmt='%a, %d %b %Y %H:%M:%S',
                        filename='/app/zabbix/alertscripts/sendSms.log',
                        filemode='a')

    try:
        seqNo = str(random.randint(0, 9)) + \
            datetime.datetime.now().strftime('%H%M%S')
        data = createSmsXml(seqNo, mobiles, subject + message)
        ret = http_post(
            "http://11.111.9.3:10026/psbc-wsproxyserver/execute", data)
        logging.info("SMS-send success [mobile: " + mobiles +
                     ",subject:" + subject +  ", message:" + message + "]")
    except:
        logging.error("SMS-send fail [mobile: " + mobiles +
                      ",subject:" + subject + ", message:" + message + "]")

    # print (createSmsXml("xxxxx", "13822142543,11122333", "test"))

    # seqNo = datetime.datetime.now().strftime('%H%M%S')+"0"
    # data = createSmsXml(seqNo, "13822142543,11122333", "test")
    #ret = http_post("http://20.223.0.49:10026/", data)

    # XXX = "<SoapService><ServiceHeader><SeqNo>5803901</SeqNo> </ServiceHeader> <ServiceBody><SMSRs><Result>xxxxxx</Result></SMSRs></ServiceBody></SoapService>"
    # print(parseXml(XXX))

    # print(datetime.datetime.now().strftime('%H%M%S')+"0");

    # mobiles = "13822142543"
    # subject = "sub-"
    # message = "message"

    # #################################################################################################
    # # 定义一个RotatingFileHandler，最多备份5个日志文件，每个日志文件最大10M
    # Rthandler = RotatingFileHandler('sendSms.log', maxBytes=10*1024*1024, backupCount=5)
    # Rthandler.setLevel(logging.DEBUG)
    # formatter = logging.Formatter('%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s', datefmt='%a, %d %b %Y %H:%M:%S')
    # Rthandler.setFormatter(formatter)
    # logging.getLogger('').addHandler(Rthandler)
    # ################################################################################################
