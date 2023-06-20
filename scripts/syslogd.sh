#!/bin/bash

# IP-адрес MP 10 Agent
MP_IP_ADDRESS=""

# добавляем строку в конфиг /etc/syslog.conf
echo "*.info;mail.none;lpr.none;news.none;uucp.none;cron.none @${MP_IP_ADDRESS}:514" | sudo tee -a /etc/syslog.conf > /dev/null

# перезапускаем службу syslog
sudo systemctl restart syslog.service

# устанавливаем пакет audispd-plugins
sudo apt-get install audispd-plugins -y

# определяем путь к файлу syslog.conf для audispd-plugins
if [ -d "/etc/audit/plugins.d" ]; then
    AUDISPD_PLUGIN_CONF="/etc/audit/plugins.d/syslog.conf"
else
    AUDISPD_PLUGIN_CONF="/etc/audisp/plugins.d/syslog.conf"
fi

# добавляем и редактируем значения параметров в файле syslog.conf
sudo sed -i 's/^active.*/active = yes/' $AUDISPD_PLUGIN_CONF
sudo sed -i 's/^args.*/args = LOG_LOCAL6/' $AUDISPD_PLUGIN_CONF

# перезапускаем службу auditd
sudo systemctl restart auditd.service
