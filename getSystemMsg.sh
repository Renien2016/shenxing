#!/bin/bash
#auth:lwq
#version:1.0
#功能：主要是收集服务器硬件信息

[[ -z `rpm -qa|grep dmidecode` ]] && yum install -y dmidecode &>/dev/null

echo -e "*******************\033[36m【服务器信息收集显示】\033[0m***************************"
echo -e "\033[32m服务器型号  ：\033[0m" `dmidecode | grep "Product Name:"|sed -n '1p'|awk -F': ' '{print $2}'`
echo -e "\033[32m操作系统版本：\033[0m" `cat /etc/redhat-release` 
echo -e "\033[32m内核版本    ：\033[0m" `uname -a|awk '{print $1,$3}'`
echo -e "\033[32mCPU型号     ：\033[0m"  `cat /proc/cpuinfo | grep "model name" | uniq |awk -F': ' '{print $2}'`
echo -ne "\033[32mCPU物理个数 ：\033[0m `cat /proc/cpuinfo | grep "physical" | sort -u| wc -l`\033[33m  |  \033[0m"
echo -ne "\033[32mCPU核数 ：\033[0m `cat /proc/cpuinfo | grep "cpu cores" | uniq |awk -F': ' '{print $2}'`\033[33m  |  \033[0m"
echo -e "\033[32mCPU逻辑个数 ：\033[0m" `cat /proc/cpuinfo | grep "cpu cores" | uniq |awk -F': ' '{print $2}'`
echo -ne "\033[32m内存大小    ：\033[0m `free -m|awk 'NR==2{print $2" MB"}'`    \033[33m|    \033[0m"
echo -e "\033[32mSwap大小    ：\033[0m" `free -m|awk '/Swap/{print $2"MB"}'`
echo -ne "\033[32mSelinux状态 ：\033[0m `getenforce`\033[33m  |    \033[0m"
echo -e "\033[32m防火墙状态  ：\033[0m" $([[ -z `uname -r|grep "el7"` ]] && { service iptables status|head -1 |grep iptables &>/dev/null && echo "Iptables[dead]" || echo "Iptables[running]"; } || systemctl status firewalld | egrep  "dead|running"|sed 's@).*@)@;s@.*(@Firewalld(@')
echo -e "\033[32m当前网卡信息：\033[0m"
for hw in `ip a|awk -F ':' '/mtu.*UP.*qlen/{print $2}'`
do
 	echo "$hw " `ip a show  $hw|awk '/inet /{print $2}'|xargs -n2` |awk '{printf "\033[33m%9s   ：\033[0m %10s %s\n",$1,$2,$3}'
done
echo -e "\033[32m当前负载    ：\033[0m" `uptime|sed 's@.*average:@@'`
echo -e "\033[32m硬盘信息    ：\033[0m" 
df -lh|awk -F '[% ]+' '{if(NR==1)print "\033[33m"$0"\033[0m";else if($5>90)print "\033[31m"$0"\033[0m"; else print $0}'
echo "*******************************************************************"
