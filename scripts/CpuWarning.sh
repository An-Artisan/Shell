#!/usr/bin/bash  
#监控系统cpu的情况脚本程序  
  
#提取本服务器的IP地址信息  
IP=`ifconfig eth0 | grep "inet "|awk '{print $2}'`  
  
#取当前空闲cpu百份比值（只取整数部分）  
cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $8}' | cut -f 1 -d "."`  
  
#设置空闲cpu的告警值为20%，如果当前cpu使用超过80%（即剩余小于20%），立即发邮件告警  
if (($cpu_idle < 20)); then  
      echo "IP为 $IP 的腾讯云服务器cpu剩余$cpu_idle%，使用率已经超过80%，请及时处理。" | mutt -s "$IP 服务器CPU告警"  13330295142@163.com  
fi
