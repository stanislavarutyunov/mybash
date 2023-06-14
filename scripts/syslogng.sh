#!/bin/bash

# Создание файла 10-siem.conf и добавление в него необходимых настроек 
sudo touch /etc/syslog-ng/10-siem.conf
sudo chmod 666 /etc/syslog-ng/10-siem.conf

echo 'filter pt_siem_filter { not facility(mail, lpr, news, uucp, cron); };
destination siem_agent_udp { udp("<IP-адрес MP 10 Agent>" port(514)); };
log { source(s_src); filter(pt_siem_filter); destination(siem_agent_udp); };' | sudo tee -a /etc/syslog-ng/10-siem.conf

# Добавление строки @include "10-siem.conf" в конфигурационный файл syslog-ng 
sudo sed -i '/@include "scl.conf";/a @include "10-siem.conf";' /etc/syslog-ng/syslog-ng.conf

# Перезапуск службы syslog-ng
sudo systemctl restart syslog-ng.service