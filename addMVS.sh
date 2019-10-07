#!/bin/bash

#version:1.0


#read -p "Please enter the ticketing server IP:" IP
MYSQL_CMS_USER=oristar
MYSQL_CMS_PASS=Ticketcms3
IPRules="172 10 192"




#read -p "Please enter the ticketing server IP:" IP
if [[ -z $IP ]] ;then
for ips in `echo $IPRules|xargs -n1` ;
do	
IP=`ip a|awk -F '[ /]+' "/inet .*$ips.*scope/{if(\\$NF~\"^e\")print \\$3}"`
done
fi
[[ -z $IP ]] && { echo -e "\033[31mIP不能为空";exit 1; }

sed -i "s@http://.*:104@http://$IP:104@" /usr/local/CmsWebApp/apache-tomcat-6.0.39/webapps/cms-mvs/WEB-INF/classes/config/config.properties
/etc/init.d/cms-web restart

2>/dev/null mysql -u$MYSQL_CMS_USER -p$MYSQL_CMS_PASS -e "
update CMS.CI_SYS_PARAM set  DEFAULT_VALUE='http://$IP:10468/cms-mvs/' WHERE name = '排期展示URL';
select DEFAULT_VALUE,name from CMS.CI_SYS_PARAM WHERE name = '排期展示URL';" > tmp

[[ -z `cat tmp` ]] && echo -e "\033[31mMVS add fail,Please check the database network\033[0m" || echo -e "\033[32m"`cat tmp|awk '/http/{print $2" : "$1}'`"\033[0m"

#&& {
#			echo -e "\033[32mMVS配置成功.\033[0m"
#		} || {
#
#			echo -e "\033[31mMVS配置失败.请检查配置\033[0m"
#			exit 1
#		}

