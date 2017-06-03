#!/usr/bin/bash  
#把系统负载监控生成的load_day.txt文件通过邮件发送给1090035743@qq.com邮箱 
  
#提取本服务器的IP地址信息  
IP=`ifconfig eth0 | grep "inet "|awk '{print $2}'`  
  
#提取当前日期  
today=`date -d "0 day" +%Y年%m月%d日`  
  
#发送系统负载监控结果邮件  
echo "这是IP地址为：$IP的腾讯云服务器$today的系统负载监控报告，请下载附件。" |mutt -s "$IP服务器$today的系统负载监控报告" 13330295142@163.com  -a /var/www/html/Shell/scripts/load_day.txt 
