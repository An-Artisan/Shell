针对CentOS7的 监控服务器系统负载情况以及监控服务器系统负载情况
=============================
监控服务器系统负载情况
<br>
uptime 查看
[root@VM_66_137_centos scripts]# uptime
<br>
22:00:58 up 7 days, 41 min,  2 users,  load average: 0.39, 0.27, 0.23
<br>
"load average"意思分别是1分钟、5分钟、15分钟内系统的平均负荷。
<br>
主要观察"15分钟系统负荷"，将它作为电脑正常运行的指标。
<br>
如果当系统负荷达到5.0、当系统负荷持续大于0.7、当系统负荷持续大于1.0、如果15分钟内，（系统负荷除以CPU核心数目之后的）平均负荷大于1.0、就发送邮件。
<br>
发送邮件具体请百度Linux mutt
<br>
查看CPU核数 cat /proc/cpuinfo
-----------------------------
<br>
监控系统cpu的情况，当使用超过80%的时候发告警邮件
<br>
top -b -n 1 | grep Cpu | awk '{print $8}' | cut -f 1 -d "." 查看CPU空闲百分比
#######
<br>
最后添加脚本到定时任务中
<br>
crontab -e 
<br>
*/10 * * * *  /var/www/html/Shell/scripts/LoadCheck.sh > /dev/null 2>&1
<br>
*/10 * * * *  /var/www/html/Shell/scripts/LoadWarning.sh  
<br>
0 8 * * *  /var/www/html/Shell/scripts/SendMailLoad.sh
<br>
*/10 * * * *  /var/www/html/Shell/scripts/CpuCheck.sh
<br>
*/10 * * * *  /var/www/html/Shell/scripts/CpuWarning.sh
<br>
0 8 * * *  /var/www/html/Shell/scripts/SendMailCpu.sh
<br>
然后重启
<br>
CentOS的crond服务重启如下
<br>
/bin/systemctl restart crond.service
<br>
#####
系统负载与CPU占用率每十分钟检测一次，有告警则立即发邮件(十分钟发一次)。
<br>
负载与CPU检测结果邮件每天早上8点发一次。
<br>

