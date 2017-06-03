#!/bin/bash  
#把生成的cpu.txt文件通过邮件发送给用户  
  
#提取本服务器的IP地址信息  
IP=`ifconfig eth0 | grep "inet "|awk '{print $2}'`  
  
#提取当前日期 
today=`date -d "0 day" +%Y年%m月%d日`  
  
#发送cpu监控结果邮件  
echo "这是IP为：$IP 的腾讯云服务器$today的cpu监控报告，请下载附件。" | mutt -s  13330295142@163.com  "$IP服务器$today的CPU监控报告" -a /var/www/html/Shell/scripts/cpu.txt  
