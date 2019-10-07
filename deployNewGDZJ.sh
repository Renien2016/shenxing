#!/bin/bash

wget   -O  /home/oristartech/gdzj_test.tar.gz  ftp://oriftp:Ori2Ftppw@58.62.144.229/tmp/gdzj_test.tar.gz
cd  /home/oristartech/ ;  
tar   zxvf      gdzj_test.tar.gz ;   
cd  gdzj_test/
keyIP=`cat /usr/local/GYStandardServer/config/config.main |awk '/NOTICE_LOCAL_ADDRESS/{print $3}'`

[[ -z $keyIP ]] && {
	echo "获取[NOTICE_LOCAL_ADDRESS]IP失败,脚本退出"
	exit 1
}|| {
	sed -i "s@NOTICE_LOCAL_ADDRESS =.*@NOTICE_LOCAL_ADDRESS = $keyIP@" config/config.main 
	./start.sh   release
	echo  "* * * * *  root  /home/oristartech/gdzj_test/check_gys.sh" >>/etc/crontab
	echo "退出并恢复旧组件,请执行：./exit.sh "	
}


