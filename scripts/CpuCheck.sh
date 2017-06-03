#!/usr/bin/bash  
#使用top命令监控linux系统cpu变化  
  
#取系统当前时间（以追加的方式写入文件>>）  
date >> /var/www/html/Shell/scripts/datetime-cpu.txt     
  
#抓取当前cpu的值（以追加的方式写入文件>>）  
top -b -n 1 | grep Cpu  >> /var/www/html/Shell/scripts//cpu-now.txt   
  
#逐行连接上面的时间和cpu相关行数据（每次重新写入文件>）  
paste  /var/www/html/Shell/scripts/datetime-cpu.txt  /var/www/html/Shell/scripts/cpu-now.txt  > /var/www/html/Shell/scripts/cpu.txt
