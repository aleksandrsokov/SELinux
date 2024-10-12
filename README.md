# SELinux

1. Запустить nginx на нестандартном порту  
   Проблемы были решены двумя способами  
   добавление порта в разрешенные semanage port -a -t http_port_t -p tcp 4444  
   при помощи создания модуля grep nginx /var/log/audit/audit.log | audit2allow -M nginx  
   результаты в файле nginx/screen.txt  

2. Обеспечение работоспособности приложения при включенном SELinux  
   был не правильный контекст безопаснтности: type=AVC msg=audit(1728721800.714:80): avc:  denied  { add_name } for  pid=650 comm="isc-net-0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:named_conf_t:s0 tclass=dir permissive=0  
   решение проблемы: chcon -R -t named_zone_t /etc/named  

   скреен выполнения:  

   клиент:  
   nsupdate -k /etc/named.zonetransfer.key  
   > server 192.168.50.10  
   > zone ddns.lab  
   > update add www.ddns.lab. 60 A 192.168.50.15  
   > send  
   update failed: SERVFAIL  
   > quit  
   [root@client ~]# cat /var/log/audit/audit.log | audit2why  
   [root@client ~]#  
   на клиенте проблем не обнаружено 

   скриен сервера:  
   cat /var/log/audit/audit.log | audit2why  
   type=AVC msg=audit(1728721800.714:80): avc:  denied  { add_name } for  pid=650 comm="isc-net-0000" name="named.ddns.lab.view1.jnl"   scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:named_conf_t:s0 tclass=dir permissive=0  

	Was caused by:  
		Missing type enforcement (TE) allow rule.  

		You can use audit2allow to generate a loadable module to allow this access.  

   chcon -R -t named_zone_t /etc/named  
   [root@ns01 ~]# ls -laZ /etc/named  
   total 28  
   drw-rwx---.   3 root named system_u:object_r:named_zone_t:s0  121 Oct 12 07:45 .  
   drwxr-xr-x. 103 root root  system_u:object_r:etc_t:s0        8192 Oct 12 08:28 ..  
   drw-rwx---.   2 root named system_u:object_r:named_zone_t:s0   88 Oct 12 08:36 dynamic  
   -rw-rw----.   1 root named system_u:object_r:named_zone_t:s0  782 Oct 12 07:45 named.50.168.192.rev  
   -rw-rw----.   1 root named system_u:object_r:named_zone_t:s0  608 Oct 12 07:45 named.dns.lab  
   -rw-rw----.   1 root named system_u:object_r:named_zone_t:s0  608 Oct 12 07:45 named.dns.lab.view1  
   -rw-rw----.   1 root named system_u:object_r:named_zone_t:s0  655 Oct 12 07:45 named.newdns.lab

   клиент:  
   [root@client ~]# #####после исправления#######  
   [root@client ~]# nsupdate -k /etc/named.zonetransfer.key  
   > server 192.168.50.10  
   > zone ddns.lab  
   > update add www.ddns.lab. 60 A 192.168.50.15  
   > send  
   > quit  
   [vagrant@client ~]$ dig @192.168.50.10 www.ddns.lab +short  
   192.168.50.15  
   [vagrant@client ~]$   


  


