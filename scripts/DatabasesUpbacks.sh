#usr/bin/bash
#当前服务器数据库的备份

#定义数据库登录的基本信息
#数据库信息定义  

# mysql主机名 这里是本机
mysql_host="localhost"  
# mysql用户
mysql_user="root"  
# mysql密码
mysql_password="JokerHosting520"  
  
# sql备份目录  注意：这里要定义绝对路径
databases_dir="/var/www/html/Shell/scripts/DataBasesUpbacks"
# 如果该目录不存在，则创建
if [ ! -d "$databases_dir" ]; then  
    mkdir -p "$databases_dir"  
fi
# 获取该数据库的所有数据库，用来循环遍历备份
databases_string=$(echo "show databases;" | mysql -u$mysql_user -p$mysql_password -h$mysql_host)
# 定义不需要的数据库和信息
non_essential="Database information_schema mysql performance_schema"
# 定义当前日期 如20170604 格式
date=$(date -d '+0 days' +%Y%m%d) 
#定义zip打包信息
zip_name="upbacks_mysql__"$date".tar.gz" 
# 进入到备份目录 
cd $databases_dir
# 获取个数，分隔符用空格
database_value_count=`echo $databases_string | awk  'BEGIN {FS=" "} {print NF}'` 
# 循环备份数据库
for ((i=1; i <= $database_value_count;i++))
do
	# 获取有多少数据库
       	databases[$i]=`echo $databases_string | awk -v col_number="${i}" 'BEGIN {FS=" "} {print $col_number}'`
	# 判断不需要的数据库是否存在
        result=$(echo $non_essential | grep "${databases[$i]}")
	# 不需要的数据库不存在才备份
        if [[ "$result" == "" ]]
        then
          # 拼接备份文件名
          sqlfile=${databases[$i]}-$date".sql"
          # 开始备份数据库
          mysqldump -u$mysql_user -p$mysql_password -h$mysql_host ${databases[$i]} > ./"$sqlfile"
        fi
done

#tar压缩打包所有的sql文件  
tar -zcvf $zip_name ./
echo "这是服务器数据库的备份文件，请下载保存"|mutt -s "数据库备份"  13330295142@163.com -a /var/www/html/Shell/scripts/DataBasesUpbacks/"$zip_name"
#发送邮件成功成功后删除备份的文件  
if [ $? -eq 0 ]; then  
   #删除备份的文件
   rm -rf $databases_dir  
fi  
