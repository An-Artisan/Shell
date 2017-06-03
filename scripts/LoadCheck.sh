#!/usr/bin/bash  
#使用uptime命令监控linux系统负载变化  
  
#取系统当前时间（以追加的方式写入文件>>）  
date >>/var/www/html/Shell/scripts/datetime-load.txt     
  
#提取服务器1分钟、5分钟、15分钟的负载情况  
uptime | awk '{print $8,$9,$10,$11,$12}' >> /var/www/html/Shell/scripts/load.txt  
  
#逐行连接上面的时间和负载相关行数据（每次重新写入文件>）  
paste  /var/www/html/Shell/scripts/datetime-load.txt /var/www/html/Shell/scripts/load.txt   > /var/www/html/Shell/scripts/load_day.txt
