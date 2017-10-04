#!/bin/bash

mysql -uoristar -pTicketcms3 -e "use ORST_CLOUD;update orst_tenant_info set status=1 where id = 2;SELECT * from ORST_CLOUD.orst_tenant_info;"


cd /usr/local/CmsLogicServer/;\cp configDatabase.sh db.sh;sed -i "11s@.*@DBServerIP=`ifconfig |awk -F '[: ]+' '/addr:122/{print $4}'`@;12s@.*@DBUser=oristar@;13s@.*@DBPassword=Ticketcms3@" db.sh;sh db.sh

\cp configSystem.sh sy.sh;sed -i '9s@.*@ValidateKey=12345678@' sy.sh;sh sy.sh;

\cp configGrid.sh gr.sh;sed -i '37s@.*@AdminUserName=oristar@;38s@.*@AdminPassword=Ticketcms3@' gr.sh;sed  -i '30s@.*@ch=$MasterMode@;31d;92d' gr.sh;sh gr.sh;

cd /usr/local/CmsWebApp/;\cp configWebApp.sh we.sh

sed -i "43s@.*@ValidateKey=12345678@;48s@.*@LocalLogicAddress=`ifconfig |awk -F '[: ]+' '/addr:122/{print $4}'`@;52s@.*@LocalLogicAddress=`ifconfig |awk -F '[: ]+' '/addr:122/{print $4}'`@" we.sh;sed  -i '37s@.*@ch=$SingleMode@;38d;114d' we.sh;sh we.sh
  
cd /usr/local/CmsInterface/;\cp configInterface.sh iner.sh;sed -i "28s@.*@ValidateKey=12345678@;33s@.*@LocalLogicAddress=`ifconfig |awk -F '[: ]+' '/addr:122/{print $4}'`@" iner.sh;sh iner.sh;

cd /usr/local/CmsReportApp/;\cp configReportApp.sh rep.sh

sed -i "32s@.*@DBServerIP=`ifconfig |awk -F '[: ]+' '/addr:122/{print $4}'`@;33s@.*@DBUser=oristar@;34s@.*@DBPassword=Ticketcms3@" rep.sh;sh rep.sh

cd /usr/local/CmsRecovery/;sh configRecovery.sh

cd /usr/local/GYStandardServer/;\cp configGYService.sh gys.sh;sed -i '26s@.*@ValidateKey=12345678@' gys.sh;sh gys.sh

cd /usr/local/CmsLogicServer/;rm -rvf db.sh gr.sh sy.sh;cd /usr/local/CmsWebApp/;rm -rvf we.sh;cd /usr/local/CmsInterface/;rm -rvf iner.sh ;cd /usr/local/CmsReportApp;rm -rvf rep.sh;cd /usr/local/GYStandardServer/;rm -rvf gys.sh


 
sed -i "s@serveraddress=\"10.0.*\"@serveraddress=\"`ifconfig |awk -F '[: ]+' '/addr:122/{print $4}'`\"@" /usr/local/CmsLogicServer/config/grid/gridAppCfg.xml;grep "server-instance.*serveraddress" /usr/local/CmsLogicServer/config/grid/gridAppCfg.xml

sed -i "s@NETSALE_SIGN_VERIFY =.*@NETSALE_SIGN_VERIFY = 0@;s@^USBKEY_NET_ENABLE.*@USBKEY_NET_ENABLE = 0@;s@USBKEY_SERVER_HOST =.*@USBKEY_SERVER_HOST = 59.252.101.9@;s@SSL_AUTH_TYPE =.*@SSL_AUTH_TYPE = 1@" /usr/local/GYStandardServer/config/config.main;egrep "^(NETSAL|USBKEY_SERVER_HOST|NOTICE_LOCAL_ADDRESS|SSL_AUTH_TYPE|USBKEY_NET_ENABLE)" /usr/local/GYStandardServer/config/config.main



pkill -9 ice;pkill -9 GYS;service cms-web    restart;service cms-logic  start;service cms-report restart;service cms-interface restart;/etc/init.d/iptables stop

