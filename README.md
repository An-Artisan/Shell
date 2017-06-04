针对CentOS7的 监控服务器系统负载情况、监控服务器系统负载情况、数据表备份发送指定邮件
=============================
监控服务器系统负载情况
-----------------------------
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
查看CPU核数 cat /proc/cpuinfo
-------------------------------
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

每个月定时备份mysql数据库并打包备份数据库发送到指定邮箱，发送成功就删除备份信息，不占用磁盘资源
-----------------------------
先进入数据库查看有哪些数据库
<br>
show databases;
<br>
MariaDB [(none)]> show databases;
<br>
+--------------------+
<br>
| Database           |
<br>
+--------------------+
<br>
| information_schema |
<br>
| blog               |
<br>
| makefriend         |
<br>
| manager            |
<br>
| message            |
<br>
| mysql              |
<br>
| performance_schema |
<br>
| personaladmin      |
<br>
| personalblog       |
<br>
| personalchat       |
<br>
| personalwebsite    |
<br>
| private_message    |
<br>
| secondhand         |
<br>
| study_note         |
<br>
| user               |
<br>
+--------------------+
<br>
15 rows in set (0.00 sec)
<br>
这里是我的数据库信息 可以看到第一行是Database 这不是数据库，是提示下面是数据库信息，所以这一行需要过滤
<br>
然后就是 performance_schema，information_schema，mysql 这是mysql服务器自带的数据库，也需要过滤
<br>
# mysql主机名 这里是本机
<br>
mysql_host="localhost"
<br>
# mysql用户
<br>
mysql_user="root"
<br>
# mysql密码
<br>
mysql_password="xxxxxx"
<br>
# sql备份目录  注意：这里要定义绝对路径
<br>
databases_dir="/var/www/html/Shell/scripts/DataBasesUpbacks"
<br>
这里自己定义你要备份的目录
<br>
# 如果该目录不存在，则创建
<br>
if [ ! -d "$databases_dir" ]; then
<br>
    mkdir -p "$databases_dir"
<br>
fi
<br>
# 获取该数据库的所有数据库，用来循环遍历备份
<br>
databases_string=$(echo "show databases;" | mysql -u$mysql_user -p$mysql_password -h$mysql_
host)
<br>
# 定义不需要的数据库和信息
<br>
non_essential="Database information_schema mysql performance_schema"
<br>
只需要指定 non_essential变量的内容就可以不用备份该变量内容中的数据库，一定要加上Database，因为show命令第一行会有Database，前面说过。
<br>
最后修改你的邮箱地址就可以了
<br>
echo "这是服务器数据库的备份文件，请下载保存"|mutt -s "数据库备份"  13330295142@163.com -a /var/www/html/Shell/scripts/DataBasesUpbacks/"$zip_name"
<br>
我的邮箱是13330295142@163.com 这里改成你的
<br>
最后添加到定时任务，每月1号执行
<br>
crontab -e 添加下面信息，当然脚本位置，写你自己的
<br>
0 0 1 * * /var/www/html/Shell/scripts/DatabasesUpbacks.sh
![备份截图](https://github.com/StubbornGrass/Shell/blob/master/ReadMeImages/demo1.png)
<br>
[个人主页](http://www.joker1996.com)
<br />