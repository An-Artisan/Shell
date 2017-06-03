#!/usr/bin/bash  
#使用uptime命令监控linux系统负载变化  
  
#提取本服务器的IP地址信息  
IP=`ifconfig eth0 | grep "inet "|awk '{print $2}'`  
  
#抓取cpu的总核数  
cpu_num=`grep -c 'model name' /proc/cpuinfo`  
  
#抓取当前系统15分钟的平均负载值  
load_15=`uptime | awk '{print $NF}'`  
  
#计算当前系统单个核心15分钟的平均负载值，结果小于1.0时前面个位数补0。  
average_load=`echo "scale=2;a=$load_15/$cpu_num;if(length(a)==scale(a)) print 0;print a" | bc`  
 
#取上面平均负载值的个位整数  
average_int=`echo $average_load | cut -f 1 -d "."`  
  
#设置系统单个核心15分钟的平均负载的告警值为0.70(即使用超过70%的时候告警)。  
load_warn=0.70  
  
#当单个核心15分钟的平均负载值大于等于1.0（即个位整数大于0） ，直接发邮件告警；如果小于1.0则进行二次比较  
if (($average_int > 0)); then  
      echo "$IP服务器15分钟的系统平均负载为$average_load，超过警戒值1.0，请立即处理！！！" | mutt -s "$IP 服务器系统负载严重告警！！！"  13330295142@163.com  
else  
#当前系统15分钟平均负载值与告警值进行比较（当大于告警值0.70时会返回1，小于时会返回0 ）  
load_now=`expr $average_load \> $load_warn`  
  
#如果系统单个核心15分钟的平均负载值大于告警值0.70（返回值为1），则发邮件我的邮箱
 if (($load_now == 1)); then  
    echo "$IP服务器15分钟的系统平均负载达到 $average_load，超过警戒值0.70，请及时处理。" | mutt -s "$IP 服务器系统负载告警"  13330295142@163.com  
 fi  
fi
