# SELinux

Проблемы были решены двумя способами  
добавление порта в разрешенные semanage port -a -t http_port_t -p tcp 4444  
при помощи создания модуля grep nginx /var/log/audit/audit.log | audit2allow -M nginx
результаты в файле screen.txt